Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEE7419BAF
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236668AbhI0RVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236695AbhI0RTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73AC06128E;
        Mon, 27 Sep 2021 17:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762766;
        bh=WHSjQM5z8ey52B025NzG0YTyEhmuD7BGA2Bn9yJrbMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITQ1leqvDHYloam7jYhnKzhTSRwUGNNq0UCHyp1Se3/UirF+uhiSbamM0jFyjjdbi
         XkcDlD/oo40+gkBPgvWEwp2ZPMiAspMe9Y1RR0TacPCvMcpK9lnPREn35ieai/9FJF
         PLLXTWoASTVjxfiLmTlaAKt33BtSwS6y8hJy56UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Julian Sikorski <belegdol@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.14 043/162] platform/x86: amd-pmc: Increase the response register timeout
Date:   Mon, 27 Sep 2021 19:01:29 +0200
Message-Id: <20210927170234.998866332@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3c3c8e88c8712bfe06cd10d7ca77a94a33610cd6 upstream.

There have been reports of approximately a 0.9%-1.7% failure rate in SMU
communication timeouts with s0i3 entry on some OEM designs.  Currently
the design in amd-pmc is to try every 100us for up to 20ms.

However the GPU driver which also communicates with the SMU using a
mailbox register which the driver polls every 1us for up to 2000ms.
In the GPU driver this was increased by commit 055162645a40 ("drm/amd/pm:
increase time out value when sending msg to SMU")

Increase the maximum timeout used by amd-pmc to 2000ms to match this
behavior.  This has been shown to improve the stability for machines
that randomly have failures.

Cc: stable@kernel.org
Reported-by: Julian Sikorski <belegdol@gmail.com>
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1629
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20210914020115.655-1-mario.limonciello@amd.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -71,7 +71,7 @@
 #define AMD_CPU_ID_YC			0x14B5
 
 #define PMC_MSG_DELAY_MIN_US		100
-#define RESPONSE_REGISTER_LOOP_MAX	200
+#define RESPONSE_REGISTER_LOOP_MAX	20000
 
 #define SOC_SUBSYSTEM_IP_MAX	12
 #define DELAY_MIN_US		2000


