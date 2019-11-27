Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D1E10BB27
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfK0VKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732964AbfK0VKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:10:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18052215E5;
        Wed, 27 Nov 2019 21:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889001;
        bh=xgQUw68yH/kfAzR4SkQz95hv2VB0dbTOiUS5OcoeLpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r3dlUSIiWj13tROOJ4EQjWGNg8mVVWp3uMXOYOvVQW/pYECh2S+98lYk53wZtRG8T
         WEiGVcrToGFFtiTzYOZYx+xBmjFdC0SX6MEiQbNTCdEnhZZGO8/XFdaEH2VUSxOI+l
         ysIUFB9C89UXa92zdOy2r4HL7CZRrb6KNFYxIPpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 06/95] net: sched: ensure opts_len <= IP_TUNNEL_OPTS_MAX in act_tunnel_key
Date:   Wed, 27 Nov 2019 21:31:23 +0100
Message-Id: <20191127202849.709267390@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 4f0e97d070984d487df027f163e52bb72d1713d8 ]

info->options_len is 'u8' type, and when opts_len with a value >
IP_TUNNEL_OPTS_MAX, 'info->options_len = opts_len' will cast int
to u8 and set a wrong value to info->options_len.

Kernel crashed in my test when doing:

  # opts="0102:80:00800022"
  # for i in {1..99}; do opts="$opts,0102:80:00800022"; done
  # ip link add name geneve0 type geneve dstport 0 external
  # tc qdisc add dev eth0 ingress
  # tc filter add dev eth0 protocol ip parent ffff: \
       flower indev eth0 ip_proto udp action tunnel_key \
       set src_ip 10.0.99.192 dst_ip 10.0.99.193 \
       dst_port 6081 id 11 geneve_opts $opts \
       action mirred egress redirect dev geneve0

So we should do the similar check as cls_flower does, return error
when opts_len > IP_TUNNEL_OPTS_MAX in tunnel_key_copy_opts().

Fixes: 0ed5269f9e41 ("net/sched: add tunnel option support to act_tunnel_key")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_tunnel_key.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -135,6 +135,10 @@ static int tunnel_key_copy_opts(const st
 			if (opt_len < 0)
 				return opt_len;
 			opts_len += opt_len;
+			if (opts_len > IP_TUNNEL_OPTS_MAX) {
+				NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
+				return -EINVAL;
+			}
 			if (dst) {
 				dst_len -= opt_len;
 				dst += opt_len;


