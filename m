Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C722A1582
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgJaLfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgJaLfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10DF20739;
        Sat, 31 Oct 2020 11:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144115;
        bh=HgU7niy+267yUMM8AzmdA2zEi95wlPSbB0d5YyXXaKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIbyWBw8c0r8LRfqEZMlN3jMKNBN9WTuNjkH5roLASUhPM5Nw7cuhtaeZ05lCmbhW
         HPX6dR080EdLa4CcctOyU8DLdED3x8ChP2BALEWmdPipMdNx/7Tk+8eXwNoLdoCppu
         FRl5Ee1wR/PDhWbrwVpZW9ysj1BzhS+bCmPqlQFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 11/49] bnxt_en: Send HWRM_FUNC_RESET fw command unconditionally.
Date:   Sat, 31 Oct 2020 12:35:07 +0100
Message-Id: <20201031113455.990845878@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
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
@@ -4204,7 +4204,8 @@ static int bnxt_hwrm_do_send_msg(struct
 	u32 bar_offset = BNXT_GRCPF_REG_CHIMP_COMM;
 	u16 dst = BNXT_HWRM_CHNL_CHIMP;
 
-	if (BNXT_NO_FW_ACCESS(bp))
+	if (BNXT_NO_FW_ACCESS(bp) &&
+	    le16_to_cpu(req->req_type) != HWRM_FUNC_RESET)
 		return -EBUSY;
 
 	if (msg_len > BNXT_HWRM_MAX_REQ_LEN) {


