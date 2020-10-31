Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB42A160A
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgJaLlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgJaLlM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A81520739;
        Sat, 31 Oct 2020 11:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144471;
        bh=wcmhvwojMBAzrC1ZXw/Lq7c1TEW3cDdQYgghsLsd18E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pyww8q9N7OLGMxMlaRcVBoMmVbFDHSj4qKu/dFtcj+7DfdwUqEsztSCnu0LncV+As
         c6BsYHiJ23KbSsCTBGcc2y9F0Cg5hYUjn/ui9LIwTN9zjXeA5zFWu/IMfBXPVEfWx5
         F3AvaRBqYEFfexsDWB5Lkt577CPYFky9c7VZS3iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 31/70] bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.
Date:   Sat, 31 Oct 2020 12:36:03 +0100
Message-Id: <20201031113500.991885624@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit 825741b071722f1c8ad692cead562c4b5f5eaa93 ]

In the AER or firmware reset flow, if we are in fatal error state or
if pci_channel_offline() is true, we don't send any commands to the
firmware because the commands will likely not reach the firmware and
most commands don't matter much because the firmware is likely to be
reset imminently.

However, the HWRM_FUNC_RESET command is different and we should always
attempt to send it.  In the AER flow for example, the .slot_reset()
call will trigger this fw command and we need to try to send it to
effect the proper reset.

Fixes: b340dc680ed4 ("bnxt_en: Avoid sending firmware messages when AER error is detected.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4188,7 +4188,8 @@ static int bnxt_hwrm_do_send_msg(struct
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
-	if (BNXT_NO_FW_ACCESS(bp))
+	if (BNXT_NO_FW_ACCESS(bp) &&
+	    le16_to_cpu(req->req_type) != HWRM_FUNC_RESET)
 		return -EBUSY;
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {


