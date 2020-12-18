Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2442DDC44
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 01:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732053AbgLRAFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 19:05:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732048AbgLRAFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 19:05:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608249815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hsHIgptIUWqDowDErBWPgRz3UILwytr0YhHQPDtbkNY=;
        b=W2slQ1BBYwu8WuZsHkyXC2RAAkvVWtF4rOcJ5U3NyIQNKrNeJZMdkmI/4X+Qajefe0jvnz
        El5AgVjvyY86XrP+Cxok2IOGNCgKYrKKD1f6OGCRDohgA1nEEZ3QoAuklzVCjcUbIFhnPJ
        FJtNqZM2eILvrDk6aEzArcFqq7/k9yk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-Rdu6uv2CNWWvPBQ5eJYlFA-1; Thu, 17 Dec 2020 19:03:30 -0500
X-MC-Unique: Rdu6uv2CNWWvPBQ5eJYlFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C4D5800402;
        Fri, 18 Dec 2020 00:03:14 +0000 (UTC)
Received: from prarit.bos.redhat.com (prarit-guest.7a2m.lab.eng.bos.redhat.com [10.16.222.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EFD41042989;
        Fri, 18 Dec 2020 00:02:32 +0000 (UTC)
Subject: Re: [RHEL8.4 bz1886943] acpi-cpufreq: Honor _PSD table setting on new
 AMD CPUs
To:     Terry Bowman <tbowman@redhat.com>, ahs3@redhat.com,
        lszubowi@redhat.com, darcari@redhat.com, WeHuang@redhat.com
Cc:     Wei Huang <wei.huang2@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "3 . 10+" <stable@vger.kernel.org>, rhkernel-list@redhat.com
References: <20201217210120.912748-1-tbowman@redhat.com>
From:   Prarit Bhargava <prarit@redhat.com>
Message-ID: <bdd50db6-d72f-a8d7-56ab-0ad4ff46c4e8@redhat.com>
Date:   Thu, 17 Dec 2020 19:02:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20201217210120.912748-1-tbowman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/17/20 4:01 PM, Terry Bowman wrote:
> Bugzilla: http://bugzilla.redhat.com/1886943
> Brew: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=33761621
> Upstream: 5.10-rc, https://lkml.org/lkml/2020/10/19/488
> Test: Manual testing looking for PSD override in dmesg.
> Using amd-daytona-01.khw1.lab.eng.bos.redhat.com, EPYC Milan
>
> commit 5368512abe08 ("acpi-cpufreq: Honor _PSD table setting on new AMD CPUs")
> Author: Wei Huang <wei.huang2@amd.com>
> Date:   Sun Oct 18 22:57:41 2020 -0500
>
>     acpi-cpufreq: Honor _PSD table setting on new AMD CPUs
>
>     acpi-cpufreq has a old quirk that overrides the _PSD table supplied by
>     BIOS on AMD CPUs. However the _PSD table of new AMD CPUs (Family 19h+)
>     now accurately reports the P-state dependency of CPU cores. Hence this
>     quirk needs to be fixed in order to support new CPUs' frequency
>     control.
>
> Fixes: acd316248205 ("acpi-cpufreq: Add quirk to disable _PSD usage on all AMD
CPUs")
> Signed-off-by: Wei Huang <wei.huang2@amd.com>
> [ rjw: Subject edit ]
> Cc: 3.10+ <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> [ tb: reformat for checkpatch ]
> Signed-off-by: Terry Bowman <tbowman@redhat.com>
>

Acked-by: Prarit Bhargava <prarit@redhat.com>

P.

