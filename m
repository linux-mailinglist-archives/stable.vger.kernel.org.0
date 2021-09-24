Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A704172EF
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344479AbhIXMw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344098AbhIXMvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:51:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F52561356;
        Fri, 24 Sep 2021 12:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487737;
        bh=1MnyEl/YcD4QKPzLbmybZku7sKyS6YAmGlF4WtxefJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zXxQoVui3LqlAo0ktgnHuFOVfyV5brhUz2gu/bQJ5GhuvqnIAaVG+NfIReTwoQqEP
         uwgiTM08PXvOMMKzszKq68BQsIt1iVAXgEARmEyabixWiRYibDEVSMDg1KGm0N7caK
         CE0hdk0gM/2tPCtEvHGmaRaIXuIyRwDoKn0q8DBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/34] sctp: add param size validation for SCTP_PARAM_SET_PRIMARY
Date:   Fri, 24 Sep 2021 14:44:02 +0200
Message-Id: <20210924124330.236794802@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124329.965218583@linuxfoundation.org>
References: <20210924124329.965218583@linuxfoundation.org>
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
@@ -2172,9 +2172,16 @@ static enum sctp_ierror sctp_verify_para
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


