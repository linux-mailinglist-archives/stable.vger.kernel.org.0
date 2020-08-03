Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67EC23A664
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgHCMr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:47:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:50716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgHCMZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A36D7204EC;
        Mon,  3 Aug 2020 12:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457544;
        bh=h34qtxaIin9fvca5iz4rgj6oOZSApYPiXFr73+LDPjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1H7EE/34Kj67DdIf2hGLxN1+Rfny9Nh9mSgUro4TATRiZX9NgPa580wxx502/wppN
         sAq39GZ5cyAFXVgCfyxMQhq/uxWI6VTb9lqwjVvPpTWkm0GPvVa5SFZWNMk1ssj7P5
         FPhL8xAgEeT8IhfVv+Oi0k5yAU9bP3U9r2Stry/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Pisati <paolo.pisati@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 107/120] selftest: txtimestamp: fix net ns entry logic
Date:   Mon,  3 Aug 2020 14:19:25 +0200
Message-Id: <20200803121908.117285163@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

[ Upstream commit b346c0c85892cb8c53e8715734f71ba5bbec3387 ]

According to 'man 8 ip-netns', if `ip netns identify` returns an empty string,
there's no net namespace associated with current PID: fix the net ns entrance
logic.

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/txtimestamp.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/txtimestamp.sh b/tools/testing/selftests/net/txtimestamp.sh
index eea6f5193693f..31637769f59f6 100755
--- a/tools/testing/selftests/net/txtimestamp.sh
+++ b/tools/testing/selftests/net/txtimestamp.sh
@@ -75,7 +75,7 @@ main() {
 	fi
 }
 
-if [[ "$(ip netns identify)" == "root" ]]; then
+if [[ -z "$(ip netns identify)" ]]; then
 	./in_netns.sh $0 $@
 else
 	main $@
-- 
2.25.1



