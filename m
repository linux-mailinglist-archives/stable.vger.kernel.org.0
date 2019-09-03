Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A726A620E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfICG6x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 02:58:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46829 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfICG6x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 02:58:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id m3so8562676pgv.13
        for <stable@vger.kernel.org>; Mon, 02 Sep 2019 23:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uoHHEgFr/r/SO8I5nMCow7X4j/JyWHdeMkJD+GMFPiE=;
        b=PdwDeQPp9bRkpVyUB8ZnEfizHOBfcvi+IexgeYYfm0/QujYrw17S3BbX9Astr2LmOX
         zwkG55XZnK9eNPTmFKugnMZRQotzoCWVW/1vV7dTgHOAKn7mRI//mOOmY75xG/yd1G74
         7tJ8WqV0Qm29EjB6IVpudwwyrsqXRmoSAJHKGqWL2lb/Es9uH3EwFA1ft99E5+x6bXkF
         WfEt4tpdpy0HSafEI6XChqqIrkgf6i4nx+wPTt+WNJ0l26isH8+dgP/mZ5wr1RHRs9Dz
         TdI4Z3cuNxAQcAMWmuTOZIxy20vEqn+feb17ZRe4whsQKVXDRHYc8O28bz5bnVYEJDtd
         H05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uoHHEgFr/r/SO8I5nMCow7X4j/JyWHdeMkJD+GMFPiE=;
        b=nkbq0GiI0FOfNLhPHxIWso4pWoYVoZ01L8rWjEZc0bQWnhPHhqni5m8eWZt3Ndtl8p
         5cAfoVWqRCK1/z3pYMYFTGYOxNPQdvXFmDMK4gV6PbWY886y0c0Alsn7GCxS+8R4az7L
         dHZ6fNU0+N9VIKAXNNH/8YqS+PYpnAgfSBHa/5sSPtDF5SRz/2+H06QNiKcKR6bAw8qR
         UdI9ka4Mo4pbV0VMtH+0H01FKP+76HYOiqHPFkD5lUKwECGtEENSWP9J6bHW1XgjxmJ5
         s+U9MTAXu1JJ7LEyltAsdVS41hG1HEopHIQZD9mVQfo1knfn9WP5+Lmxl1/xWExo0o2w
         qcjA==
X-Gm-Message-State: APjAAAU9zNVa9jLukxMDj+tWdn8NoP8ql3q4/J/x/eyYFRKhbulGQeki
        MAJSz10gvLTiRnBsIachdP8DGm+LPtJzdQ==
X-Google-Smtp-Source: APXvYqzap82tgzKvLQdG4ZjZS7aG4WDG/VFnG3s09pGmnhbkG7ylScuYPfA+bIKIxPx1knoDAwA00Q==
X-Received: by 2002:a63:1f1f:: with SMTP id f31mr26065616pgf.353.1567493932285;
        Mon, 02 Sep 2019 23:58:52 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id b126sm36847718pfa.177.2019.09.02.23.58.48
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 02 Sep 2019 23:58:51 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net
Cc:     hariprasad.kelam@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y 4/8] net: sctp: fix warning "NULL check before some freeing functions is not needed"
Date:   Tue,  3 Sep 2019 14:58:16 +0800
Message-Id: <0e71732006c11f119826b3be9c1a9ccd102742d8.1567492316.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567492316.git.baolin.wang@linaro.org>
References: <cover.1567492316.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hariprasad Kelam <hariprasad.kelam@gmail.com>

This patch removes NULL checks before calling kfree.

fixes below issues reported by coccicheck
net/sctp/sm_make_chunk.c:2586:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2652:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2667:3-8: WARNING: NULL check before some
freeing functions is not needed.
net/sctp/sm_make_chunk.c:2684:3-8: WARNING: NULL check before some
freeing functions is not needed.

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 net/sctp/sm_make_chunk.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f67df16..6dac492 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2586,8 +2586,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 	case SCTP_PARAM_STATE_COOKIE:
 		asoc->peer.cookie_len =
 			ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
-		if (asoc->peer.cookie)
-			kfree(asoc->peer.cookie);
+		kfree(asoc->peer.cookie);
 		asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
 		if (!asoc->peer.cookie)
 			retval = 0;
@@ -2652,8 +2651,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's random parameter */
-		if (asoc->peer.peer_random)
-			kfree(asoc->peer.peer_random);
+		kfree(asoc->peer.peer_random);
 		asoc->peer.peer_random = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_random) {
@@ -2667,8 +2665,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		/* Save peer's HMAC list */
-		if (asoc->peer.peer_hmacs)
-			kfree(asoc->peer.peer_hmacs);
+		kfree(asoc->peer.peer_hmacs);
 		asoc->peer.peer_hmacs = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_hmacs) {
@@ -2684,8 +2681,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 		if (!ep->auth_enable)
 			goto fall_through;
 
-		if (asoc->peer.peer_chunks)
-			kfree(asoc->peer.peer_chunks);
+		kfree(asoc->peer.peer_chunks);
 		asoc->peer.peer_chunks = kmemdup(param.p,
 					    ntohs(param.p->length), gfp);
 		if (!asoc->peer.peer_chunks)
-- 
1.7.9.5

