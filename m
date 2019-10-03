Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FB1CA85C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390958AbfJCQZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390964AbfJCQZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:25:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5247B20867;
        Thu,  3 Oct 2019 16:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119944;
        bh=yJTABhNQ8E3OsyhkcoBAnjIx9rthdXM5DCfNC8roBKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0a7ghmN585BokggbzwapzHcQ3U3CC73Bo2D58zSTejMv7opMISgZezcj/eAQ9dT7
         MROm9ohRIiGX/WKMkPAXKaiJ3HQ1JCw4YbSMCNmyEPHquRHsCGtE848X9a9WioWh7S
         49bBpPmD+/qS2Z1iP+2IDspkom8uInv7l+oFHPaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Yotam Gigi <yotam.gi@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.2 007/313] net/sched: act_sample: dont push mac header on ip6gre ingress
Date:   Thu,  3 Oct 2019 17:49:45 +0200
Message-Id: <20191003154534.232449776@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 92974a1d006ad8b30d53047c70974c9e065eb7df ]

current 'sample' action doesn't push the mac header of ingress packets if
they are received by a layer 3 tunnel (like gre or sit); but it forgot to
check for gre over ipv6, so the following script:

 # tc q a dev $d clsact
 # tc f a dev $d ingress protocol ip flower ip_proto icmp action sample \
 > group 100 rate 1
 # psample -v -g 100

dumps everything, including outer header and mac, when $d is a gre tunnel
over ipv6. Fix this adding a missing label for ARPHRD_IP6GRE devices.

Fixes: 5c5670fae430 ("net/sched: Introduce sample tc action")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Yotam Gigi <yotam.gi@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_sample.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -146,6 +146,7 @@ static bool tcf_sample_dev_ok_push(struc
 	case ARPHRD_TUNNEL6:
 	case ARPHRD_SIT:
 	case ARPHRD_IPGRE:
+	case ARPHRD_IP6GRE:
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 		return false;


