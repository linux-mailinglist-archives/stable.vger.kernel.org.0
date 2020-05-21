Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADF21DDB76
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgEUX6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730064AbgEUX6c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:32 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF2C05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i3so123452ybm.12
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3CTdtLU9g+hpHr0q6Ta29Nrbg4avUFmkJJ9K1wlDzgc=;
        b=aSE1dPVMqu8wNRgsa+2GN0518b0HVt+vwB1V7CDgdycuG0pWQSkORjn2UdQgm2cLFp
         bhL4O/ZS4PsXgm8AOCscsVkeKCJOgJkgW/J5xXssArrSholA1sQscIUDEsq4cRI0nyWc
         PIC/eyqXme2xeb6Sq5H83CrCFhvF4JpvplExo6uNBVZ0dFVYEia+KKsyxet2QcELYN/j
         xkwLTCluMO2gKXYnyp8jb6CCZ7yU3kf00sezju5FhPzXsL3x0tCqWBBitxzySEspScdD
         ypUA0MMCH4wmSBbCbfRgPTb8fvxMGcYTM9qsqtERM/l17J9vCsE7CiGVKpBjrLzwLyAZ
         d+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3CTdtLU9g+hpHr0q6Ta29Nrbg4avUFmkJJ9K1wlDzgc=;
        b=CB+YNXZYqYZ9TA3M4c1bOMxzQwIMFJ5xbeCd3I0j8a4JzkBWEmV9unmIkEx1WgVP2K
         tUvssyzK7VV+OywGiWqjKQADnMIOp9BCyncqjpe3UqoV/DMDVOZdDLISheBmDx08865W
         bVqR2Bgv4eQTNIY1IKDN3C3JQkN6cxoq+uHqe7kEFs/YM7crOY28dmxrCnBv4xUegYCn
         zm2ZiG/YVco1AuL5OL65ns6KzVBATeDPSsn+pxpeg+UCwwuG4XzQ1YIyjfMh97uwwYAr
         EbnOwXlJ8IbPAzoQufnala2SKfd81tTfcGgch+RUS92VBE1BAQ6phm+k5ydGYXK+AzjH
         kC1Q==
X-Gm-Message-State: AOAM532Pkuqm372X/WCLS3Hcf8esMRw5a5eaAlxT86dXmpRc5GdvAE1u
        vFnccv3DLVC3mwx+SPqPCXBSzH0xU3qdVg==
X-Google-Smtp-Source: ABdhPJyPGpPDBLzhJpUmeRNm8im1okm39lyd504UCcosofvT0Xhr5geKrOogB82ct43p24A82c7XxLMIIfsoYw==
X-Received: by 2002:a25:7c81:: with SMTP id x123mr19735150ybc.442.1590105511027;
 Thu, 21 May 2020 16:58:31 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:31 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-19-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 18/27] l2tp: hold tunnel while handling genl tunnel updates
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit 8c0e421525c9eb50d68e8f633f703ca31680b746 upstream.

We need to make sure the tunnel is not going to be destroyed by
l2tp_tunnel_destruct() concurrently.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index e0c3a551c9bc..71784e7542cf 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -310,8 +310,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -322,6 +322,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
 				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

