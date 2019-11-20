Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ADF103F64
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfKTPnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:43:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52858 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730103AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004bQ-1Z; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004IP-Tn; Wed, 20 Nov 2019 15:40:11 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        "Xin Long" <lucien.xin@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>
Date:   Wed, 20 Nov 2019 15:37:47 +0000
Message-ID: <lsq.1574264230.971583478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 37/83] sctp: fix the transport error_count check
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit a1794de8b92ea6bc2037f445b296814ac826693e upstream.

As the annotation says in sctp_do_8_2_transport_strike():

  "If the transport error count is greater than the pf_retrans
   threshold, and less than pathmaxrtx ..."

It should be transport->error_count checked with pathmaxrxt,
instead of asoc->pf_retrans.

Fixes: 5aa93bcf66f4 ("sctp: Implement quick failover draft from tsvwg")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/sm_sideeffect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -504,7 +504,7 @@ static void sctp_do_8_2_transport_strike
 	 * see SCTP Quick Failover Draft, section 5.1
 	 */
 	if ((transport->state == SCTP_ACTIVE) &&
-	   (asoc->pf_retrans < transport->pathmaxrxt) &&
+	   (transport->error_count < transport->pathmaxrxt) &&
 	   (transport->error_count > asoc->pf_retrans)) {
 
 		sctp_assoc_control_transport(asoc, transport,

