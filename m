Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8F633B557
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCONyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230119AbhCONxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E2DB64EED;
        Mon, 15 Mar 2021 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816416;
        bh=dZGEMZoksXRebch1qg0CmWzJNv7xDqqYd7RJtpOWILA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0CiNAM98ZPcxC+KKvZ95KUW9udOGbhsJP5m7BC/ks2YdBCyFXfnmXTRrQc5IKfZ7
         YlsEbjNuxSwIslpztXRzEXE9RQQonUDuSSwx0fqdb4z0TPt4eJ7z6sGt6ImMWRDcy6
         bLYLSmBP2rgrKeP/KsmhwE6h6fWEfoapelnFIfc4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Allen Pais <allen.pais@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: [PATCH 4.4 31/75] libertas: fix a potential NULL pointer dereference
Date:   Mon, 15 Mar 2021 14:51:45 +0100
Message-Id: <20210315135209.276935972@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Allen Pais <allen.pais@oracle.com>

commit 7da413a18583baaf35dd4a8eb414fa410367d7f2 upstream.

alloc_workqueue is not checked for errors and as a result,
a potential NULL dereference could occur.

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[krzk: backport applied to different path - without marvell subdir]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/libertas/if_sdio.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -1229,6 +1229,10 @@ static int if_sdio_probe(struct sdio_fun
 
 	spin_lock_init(&card->lock);
 	card->workqueue = create_workqueue("libertas_sdio");
+	if (unlikely(!card->workqueue)) {
+		ret = -ENOMEM;
+		goto err_queue;
+	}
 	INIT_WORK(&card->packet_worker, if_sdio_host_to_card_worker);
 	init_waitqueue_head(&card->pwron_waitq);
 
@@ -1282,6 +1286,7 @@ err_activate_card:
 	lbs_remove_card(priv);
 free:
 	destroy_workqueue(card->workqueue);
+err_queue:
 	while (card->packets) {
 		packet = card->packets;
 		card->packets = card->packets->next;


