Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F45C35BE52
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbhDLI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239082AbhDLIzm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3675061207;
        Mon, 12 Apr 2021 08:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217721;
        bh=2vlpjWMa4k7gcKDJtUV+aw0btDtN/qb3dbfGmDMAHwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1K9UYZemAqPmE9qaA/1cyytSA9g+u3+381+nyq77Zl9TDiPEUIdof9erBI+foDLrJ
         zXT3NFb8CL7JOl3gnf9QwuB6jwE96oZkpOIUbwahFDV2xKuwdYYGwGuKNymRUU6tFc
         NpfIjogUiVUjln7COONxGTBYabjGLgfSvkZxhoWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/188] net: dsa: Fix type was not set for devlink port
Date:   Mon, 12 Apr 2021 10:40:35 +0200
Message-Id: <20210412084017.672721816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

[ Upstream commit fb6ec87f7229b92baa81b35cbc76f2626d5bfadb ]

If PHY is not available on DSA port (described at devicetree but absent or
failed to detect) then kernel prints warning after 3700 secs:

[ 3707.948771] ------------[ cut here ]------------
[ 3707.948784] Type was not set for devlink port.
[ 3707.948894] WARNING: CPU: 1 PID: 17 at net/core/devlink.c:8097 0xc083f9d8

We should unregister the devlink port as a user port and
re-register it as an unused port before executing "continue" in case of
dsa_port_setup error.

Fixes: 86f8b1c01a0a ("net: dsa: Do not make user port errors fatal")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index a04fd637b4cd..3ada338d7e08 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -533,8 +533,14 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
-		if (err)
+		if (err) {
+			dsa_port_devlink_teardown(dp);
+			dp->type = DSA_PORT_TYPE_UNUSED;
+			err = dsa_port_devlink_setup(dp);
+			if (err)
+				goto teardown;
 			continue;
+		}
 	}
 
 	return 0;
-- 
2.30.2



