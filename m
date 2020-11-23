Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB0A2C07D0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733225AbgKWMo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733221AbgKWMo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7187920888;
        Mon, 23 Nov 2020 12:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135466;
        bh=JPXuScVsnSKXPKRpNGSAG1+prqoMhGHYrAoLfUA27y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNnW1uF+h6V3+kbcMsdliE+uOttkiHgILS6jMW4Ly8KnB6jtcSdt+uZ3X0NlLTn2a
         Ym2YnJsyVk32pzHcudOxHHsYp7Mwq78uXihvby6mAoqq2WH57qw4rfxP138F/siR6T
         nax+Hyw8Ro9PpnGJcl5SbROVSXViZXEzz51I1lnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 049/252] bnxt_en: Fix counter overflow logic.
Date:   Mon, 23 Nov 2020 13:19:59 +0100
Message-Id: <20201123121837.954330702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit fa97f303fa4cf8469fd3d1ef29da69c0a3f6ddc8 ]

bnxt_add_one_ctr() adds a hardware counter to a software counter and
adjusts for the hardware counter wraparound against the mask.  The logic
assumes that the hardware counter is always smaller than or equal to
the mask.

This assumption is mostly correct.  But in some cases if the firmware
is older and does not provide the accurate mask, the driver can use
a mask that is smaller than the actual hardware mask.  This can cause
some extra carry bits to be added to the software counter, resulting in
counters that far exceed the actual value.  Fix it by masking the
hardware counter with the mask passed into bnxt_add_one_ctr().

Fixes: fea6b3335527 ("bnxt_en: Accumulate all counters.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7617,6 +7617,7 @@ static void bnxt_add_one_ctr(u64 hw, u64
 {
 	u64 sw_tmp;
 
+	hw &= mask;
 	sw_tmp = (*sw & ~mask) | hw;
 	if (hw < (*sw & mask))
 		sw_tmp += mask + 1;


