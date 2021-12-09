Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E580246EA26
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhLIOmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 09:42:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48877 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238782AbhLIOlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 09:41:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639060696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SicIl/F4FCwOSzdyMa6d5C5yjU3rVhalMXpaVFqCm/w=;
        b=eowAvB/4w06vTOD+4vg1CaqtNmSyHLj+C3VzRbY7bec6QsVpGm/7KAHrkWnv8zikmJzzHt
        l1oCjr4zLTt/Ezzy6N3YLQlqBG1IClMA39unVFQV7lTaZiLzyaL7gH3QlwB0PP5l8de61h
        l60SPLC+Ip0VISq+k+Voc/NIfjv/mdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-YSOIy4BJMvWg0__xuuhKnQ-1; Thu, 09 Dec 2021 09:38:15 -0500
X-MC-Unique: YSOIy4BJMvWg0__xuuhKnQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BF65802C92;
        Thu,  9 Dec 2021 14:38:13 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.22.16.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18A9E694DF;
        Thu,  9 Dec 2021 14:38:12 +0000 (UTC)
From:   John Dorminy <jdorminy@redhat.com>
To:     tip-bot2@linutronix.de
Cc:     anjaneya.chagam@intel.com, bp@suse.de, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and early param parsing
Date:   Thu,  9 Dec 2021 09:38:10 -0500
Message-Id: <20211209143810.452527-1-jdorminy@redhat.com>
In-Reply-To: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings;

It seems that this patch causes a mem= parameter to the kernel to have no effect, unfortunately... 

As far as I understand, the x86 mem parameter handler parse_memopt() (called by parse_early_param()) relies on being called after e820__memory_setup(): it simply removes any memory above the specified limit at that moment, allowing memory to later be hotplugged without regard for the initial limit. However, the initial non-hotplugged memory must already have been set up, in e820__memory_setup(), so that it can be removed in parse_memopt(); if parse_early_param() is called before e820__memory_setup(), as this change does, the parameter ends up having no effect.

I apologize that I don't know how to fix this, but I'm happy to test patches.

Typical dmesg output showing the lack of effect, built from the prior change and this change:

With a git tree synced to 8d48bf8206f77aa8687f0e241e901e5197e52423^ (working):
[    0.000000] Command line: BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.16.0-rc1 root=UUID=a4f7bd84-4f29-40bc-8c98-f4a72d0856c4 ro net.ifnames=0 crashkernel=128M mem=4G
...
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] usable
[    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usable
[    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
[    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
[    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
[    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
[    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
...
[    0.025617] Memory: 1762876K/2061136K available (16394K kernel code, 3568K rwdata, 10324K rodata, 2676K init, 4924K bss, 298000K reserved, 0K cma-reserved)

Synced 8d48bf8206f77aa8687f0e241e901e5197e52423 (not working):

[    0.000000] Command line: BOOT_IMAGE=(hd0,msdos1)/boot/vmlinuz-5.16.0-rc4+ root=UUID=0e750e61-b92e-4708-a974-c50a3fb7e969 ro net.ifnames=0 crashkernel=128M mem=4G
[    0.000000] e820: remove [mem 0x100000000-0xfffffffffffffffe] usable
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007dd3afff] usable
[    0.000000] BIOS-e820: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000207fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] user-defined physical RAM map:
[    0.000000] user: [mem 0x0000000000000000-0x000000000009abff] usable
[    0.000000] user: [mem 0x000000000009ac00-0x000000000009ffff] reserved
[    0.000000] user: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] user: [mem 0x0000000000100000-0x000000007dd3afff] usable
[    0.000000] user: [mem 0x000000007dd3b000-0x000000007deeffff] reserved
[    0.000000] user: [mem 0x000000007def0000-0x000000007e0d3fff] ACPI NVS
[    0.000000] user: [mem 0x000000007e0d4000-0x000000007f367fff] reserved
[    0.000000] user: [mem 0x000000007f368000-0x000000007f7fffff] ACPI NVS
[    0.000000] user: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] user: [mem 0x00000000fed1c000-0x00000000fed3ffff] reserved
[    0.000000] user: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] user: [mem 0x0000000100000000-0x000000207fffffff] usable
...
[    0.695267] Memory: 131657608K/134181712K available (16394K kernel code, 3568K rwdata, 10328K rodata, 2676K init, 4924K bss, 2523844K reserved, 0K cma-reserved)

