Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1BE32912A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbhCAUUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:20:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243020AbhCAUN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BDBC653C9;
        Mon,  1 Mar 2021 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621707;
        bh=6aa/DjmiPArBrbMt0OBDXHK2TocxmIqZ/+hLTnn5w9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+Ck+VYozi7Kug4t2jQbQyHW+5IkP01UFIgFs3KbEGcxYHUetQVc6/msHOaEH04jz
         LdLUyxt9zRYhAcDAX0V31NYWBvIzcPIxUioAhSVXvqQ4nV2EBr/69CYJvb1qgkPe+d
         sOYBSnDfUx3Vinm/2tFC/Ud0Q1hGWifRn6tMvlJw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Bindu Ramamurthy <bindu.r@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 614/775] drm/amd/display: Add vupdate_no_lock interrupts for DCN2.1
Date:   Mon,  1 Mar 2021 17:13:02 +0100
Message-Id: <20210301161231.743638597@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 688f97ed3f5e339c0c2c09d9ee7ff23d5807b0a7 upstream.

When run igt@kms_vrr in a device that uses DCN2.1 architecture, we
noticed multiple failures. Furthermore, when we tested a VRR demo, we
noticed a system hang where the mouse pointer still works, but the
entire system freezes; in this case, we don't see any dmesg warning or
failure messages kernel. This happens due to a lack of vupdate_no_lock
interrupt, making the userspace wait eternally to get the event back.
For fixing this issue, we need to add the vupdate_no_lock interrupt in
the interrupt list.

Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Bindu Ramamurthy <bindu.r@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c |   22 +++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
+++ b/drivers/gpu/drm/amd/display/dc/irq/dcn21/irq_service_dcn21.c
@@ -168,6 +168,11 @@ static const struct irq_source_info_func
 	.ack = NULL
 };
 
+static const struct irq_source_info_funcs vupdate_no_lock_irq_info_funcs = {
+	.set = NULL,
+	.ack = NULL
+};
+
 #undef BASE_INNER
 #define BASE_INNER(seg) DMU_BASE__INST0_SEG ## seg
 
@@ -230,6 +235,17 @@ static const struct irq_source_info_func
 		.funcs = &vblank_irq_info_funcs\
 	}
 
+/* vupdate_no_lock_int_entry maps to DC_IRQ_SOURCE_VUPDATEx, to match semantic
+ * of DCE's DC_IRQ_SOURCE_VUPDATEx.
+ */
+#define vupdate_no_lock_int_entry(reg_num)\
+	[DC_IRQ_SOURCE_VUPDATE1 + reg_num] = {\
+		IRQ_REG_ENTRY(OTG, reg_num,\
+			OTG_GLOBAL_SYNC_STATUS, VUPDATE_NO_LOCK_INT_EN,\
+			OTG_GLOBAL_SYNC_STATUS, VUPDATE_NO_LOCK_EVENT_CLEAR),\
+		.funcs = &vupdate_no_lock_irq_info_funcs\
+	}
+
 #define vblank_int_entry(reg_num)\
 	[DC_IRQ_SOURCE_VBLANK1 + reg_num] = {\
 		IRQ_REG_ENTRY(OTG, reg_num,\
@@ -338,6 +354,12 @@ irq_source_info_dcn21[DAL_IRQ_SOURCES_NU
 	vupdate_int_entry(3),
 	vupdate_int_entry(4),
 	vupdate_int_entry(5),
+	vupdate_no_lock_int_entry(0),
+	vupdate_no_lock_int_entry(1),
+	vupdate_no_lock_int_entry(2),
+	vupdate_no_lock_int_entry(3),
+	vupdate_no_lock_int_entry(4),
+	vupdate_no_lock_int_entry(5),
 	vblank_int_entry(0),
 	vblank_int_entry(1),
 	vblank_int_entry(2),


