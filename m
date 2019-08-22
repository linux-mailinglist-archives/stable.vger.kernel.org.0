Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B7699D0A
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404152AbfHVRYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404148AbfHVRYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:17 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78A2F21743;
        Thu, 22 Aug 2019 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494656;
        bh=FWi77/lppBIOBBlfD5y2SgJK0wYJVg47OoT2P6y9i/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfVI4yzQES62R9pYaneZBw1Idddzjl0s+PIlAZoYEHIobapjLnpm2SHo3S3Y/8UFD
         68UJkiApfdD6OWfIjSPT8fXECwjSToTK5SEJfFILwUX2vpeiP4w+XtMYXHF6vi/wZm
         jwC81gjL5q9TUal2KGcyiL+ull4oE9Du4xjPurd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 4.9 098/103] sctp: fix the transport error_count check
Date:   Thu, 22 Aug 2019 10:19:26 -0700
Message-Id: <20190822171733.115889899@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit a1794de8b92ea6bc2037f445b296814ac826693e ]

As the annotation says in sctp_do_8_2_transport_strike():

  "If the transport error count is greater than the pf_retrans
   threshold, and less than pathmaxrtx ..."

It should be transport->error_count checked with pathmaxrxt,
instead of asoc->pf_retrans.

Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_sideeffect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -508,7 +508,7 @@ static void sctp_do_8_2_transport_strike
 	 */
 	if (net->sctp.pf_enable &&
 	   (transport->state == SCTP_ACTIVE) &&
-	   (asoc->pf_retrans < transport->pathmaxrxt) &&
+	   (transport->error_count < transport->pathmaxrxt) &&
 	   (transport->error_count > asoc->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,


