Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B733417499
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbhIXNId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346233AbhIXNGV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:06:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E05F561504;
        Fri, 24 Sep 2021 12:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488171;
        bh=D0ni0eWgaFtzuxhiadba7ZWnFQE2IaPsz3CfcXmufRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rn16K1u5plQvzzTyOIau7nP9SGSRw39FPNNUJu6ZceSJZGTxu7PTAFKhAmzU9Pd9X
         TYRh/Y77dkBOctvqhtezx7Foi2bXoqUjLAvBSImkiVJ1k/9HqS3tATRX8d8lFCIx9Q
         HdutIHUkNvzkDISPjWYs0BCyHqdpETnnMPy9YIcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 12/63] sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
Date:   Fri, 24 Sep 2021 14:44:12 +0200
Message-Id: <20210924124334.664861742@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

commit ef6c8d6ccf0c1dccdda092ebe8782777cd7803c9 upstream.

When SCTP handles an INIT chunk, it calls for example:
sctp_sf_do_5_1B_init
  sctp_verify_init
    sctp_verify_param
  sctp_process_init
    sctp_process_param
      handling of SCTP_PARAM_SET_PRIMARY

sctp_verify_init() wasn't doing proper size validation and neither the
later handling, allowing it to work over the chunk itself, possibly being
uninitialized memory.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2150,9 +2150,16 @@ static enum sctp_ierror sctp_verify_para
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (ep->asconf_enable)
-			break;
-		goto unhandled;
+		if (!ep->asconf_enable)
+			goto unhandled;
+
+		if (ntohs(param.p->length) < sizeof(struct sctp_addip_param) +
+					     sizeof(struct sctp_paramhdr)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
+		break;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */


