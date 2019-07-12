Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1631F66F03
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfGLMT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfGLMT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:19:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F53D208E4;
        Fri, 12 Jul 2019 12:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562933996;
        bh=mdVvnt0NyxZLQyR9PhJ/fUSa2WrIrj/Buq46zg1LSgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RLR9PpXEg4FU2WI+At+VC58QrKGLnCbmJoqFmO37QuCan1WOE8ZKRwsU9TTnCP7jL
         ccWkdMJ+97rYR0+5p8qNTYcYTSd27Le5fhjcwlc1B60do+6dS8it64m8aQFgSxfg+I
         W9bEF/8yRy791D6fFnA6RDzJvZgUMEZWfKg8dJGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/91] mac80211: free peer keys before vif down in mesh
Date:   Fri, 12 Jul 2019 14:18:16 +0200
Message-Id: <20190712121622.115217809@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0112fa557c3bb3a002bc85760dc3761d737264d3 ]

freeing peer keys after vif down is resulting in peer key uninstall
to fail due to interface lookup failure. so fix that.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0f9446ab7e4f..3162f955f3ae 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -923,6 +923,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
+	ieee80211_free_keys(sdata, true);
 	mesh_path_flush_by_iface(sdata);
 
 	/* stop the beacon */
-- 
2.20.1



