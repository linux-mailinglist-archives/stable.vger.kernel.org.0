Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228A6411B3F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbhITQ4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:39012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245667AbhITQyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E409361374;
        Mon, 20 Sep 2021 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156641;
        bh=H7A+ut54xGdFXn+yKNopAfYAAV4loLicS8xQGpK1qAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAYcdiX7f71CJb4aBlLnxJ94tnR3JPNdS7CsCdJ1W6wRC2LFgEJXOKHb2NCc61wci
         f67bTJM8ixONR6z+aT8DWtIm2YVL8OLgLt5I9VI4jqWPfdY0wQKJvCmETeTR8XIFG+
         7/myGy6E+jI4/R9kICeXuVxP2gWI7093U2c8EH2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 019/175] net/sched: cls_flower: Use mask for addr_type
Date:   Mon, 20 Sep 2021 18:41:08 +0200
Message-Id: <20210920163918.704707053@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

commit 970bfcd09791282de7de6589bfe440eb11e2efd2 upstream.

When addr_type is set, mask should also be set.

Fixes: 66530bdf85eb ('sched,cls_flower: set key address type when present')
Fixes: bc3103f1ed40 ('net/sched: cls_flower: Classify packet in ip tunnels')
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -445,6 +445,7 @@ static int fl_set_key(struct net *net, s
 
 	if (tb[TCA_FLOWER_KEY_IPV4_SRC] || tb[TCA_FLOWER_KEY_IPV4_DST]) {
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		mask->control.addr_type = ~0;
 		fl_set_key_val(tb, &key->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC,
 			       &mask->ipv4.src, TCA_FLOWER_KEY_IPV4_SRC_MASK,
 			       sizeof(key->ipv4.src));
@@ -453,6 +454,7 @@ static int fl_set_key(struct net *net, s
 			       sizeof(key->ipv4.dst));
 	} else if (tb[TCA_FLOWER_KEY_IPV6_SRC] || tb[TCA_FLOWER_KEY_IPV6_DST]) {
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		mask->control.addr_type = ~0;
 		fl_set_key_val(tb, &key->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC,
 			       &mask->ipv6.src, TCA_FLOWER_KEY_IPV6_SRC_MASK,
 			       sizeof(key->ipv6.src));
@@ -480,6 +482,7 @@ static int fl_set_key(struct net *net, s
 	if (tb[TCA_FLOWER_KEY_ENC_IPV4_SRC] ||
 	    tb[TCA_FLOWER_KEY_ENC_IPV4_DST]) {
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
+		mask->enc_control.addr_type = ~0;
 		fl_set_key_val(tb, &key->enc_ipv4.src,
 			       TCA_FLOWER_KEY_ENC_IPV4_SRC,
 			       &mask->enc_ipv4.src,
@@ -495,6 +498,7 @@ static int fl_set_key(struct net *net, s
 	if (tb[TCA_FLOWER_KEY_ENC_IPV6_SRC] ||
 	    tb[TCA_FLOWER_KEY_ENC_IPV6_DST]) {
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		mask->enc_control.addr_type = ~0;
 		fl_set_key_val(tb, &key->enc_ipv6.src,
 			       TCA_FLOWER_KEY_ENC_IPV6_SRC,
 			       &mask->enc_ipv6.src,


