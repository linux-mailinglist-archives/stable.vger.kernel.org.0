Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5759E4172B3
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344590AbhIXMut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344083AbhIXMtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 053936126A;
        Fri, 24 Sep 2021 12:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487654;
        bh=QscHcNFyegjm4aIZztu9AvAgUWGKXCU51yuh5M/VAmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG/P/y6T3ndLfkGYfC6oBVahaUtnhdCEBIyLW0BHkhd4y2+Bel1ZYBqlTtaJ8fG9b
         zQVVV7EQwkDyO+aRPEXqsBdnadKCK0LpTUjl7WRuDGy6qWjrOliHncoBVg4iPBW6Xi
         pUuqLT+R+fVfjXBJxuqV/fFXm+nvrSlq+1RMWfxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 06/27] sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
Date:   Fri, 24 Sep 2021 14:44:00 +0200
Message-Id: <20210924124329.387539276@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.173674820@linuxfoundation.org>
References: <20210924124329.173674820@linuxfoundation.org>
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
@@ -2161,9 +2161,16 @@ static enum sctp_ierror sctp_verify_para
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (net->sctp.addip_enable)
-			break;
-		goto fallthrough;
+		if (!net->sctp.addip_enable)
+			goto fallthrough;
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


