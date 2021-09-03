Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797FF3FFC49
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 10:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348417AbhICIul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 04:50:41 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39240 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348276AbhICIuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 04:50:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0FD5122663;
        Fri,  3 Sep 2021 08:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630658980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Etfp5KRM0ihxlz1Fzg+3n+yV+gWrXCILk5YBRRiJ4ec=;
        b=g/xCu4uUEeLNVhfh4hdAtjtyZDkPPqU9rW19W5JYaL63cE3RPFwRsK8D5oSo5RKnUyhZef
        oRJKvg5r8mEK1qPZy47OOCWYT8N3Ja1dGzT5F+tieQLSPZ2csfGh8mApFEuhAiWEv2KpMv
        5oLIfL7iry/5ho/b6+Y9oBZRKXdYVLY=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 6EBBF1374A;
        Fri,  3 Sep 2021 08:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id YQ4TGaPhMWFjdAAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 03 Sep 2021 08:49:39 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/2] xen: fix illegal rtc device usage of pv guests
Date:   Fri,  3 Sep 2021 10:49:35 +0200
Message-Id: <20210903084937.19392-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent change in mc146818_get_time() resulted in WARN splats when
booting a Xen PV guest.

The main reason is that there is a code path resulting in accessing a
RTC device which is not present, which has been made obvious by a
call of WARN() in this case.

This small series is fixing this issue by:

- avoiding the RTC device access from drivers/base/power/trace.c in
  cast there is no legacy RTC device available
- resetting the availability flag of a legacy RTC device for Xen PV
  guests

Juergen Gross (2):
  PM: base: power: don't try to use non-existing RTC for storing data
  xen: reset legacy rtc flag for PV domU

 arch/x86/xen/enlighten_pv.c |  7 +++++++
 drivers/base/power/trace.c  | 10 ++++++++++
 2 files changed, 17 insertions(+)

-- 
2.26.2

