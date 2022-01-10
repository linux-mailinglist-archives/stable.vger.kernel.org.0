Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526354890C1
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239313AbiAJHZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:25:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239317AbiAJHYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:24:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1883DB811F5;
        Mon, 10 Jan 2022 07:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614D5C36AED;
        Mon, 10 Jan 2022 07:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799466;
        bh=pcw/Sg/w0E9cf2w+sEgUp/zOjqIvw3IKwr7bxLEonhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqqBotNswcHAXruaHM5F0jZDfChOPoaVknaVP5L2UCO66GKAZtupKywS/3ZrjXeAE
         dxP/OQzTUt7jEG6rHKKI9hRd6shB+4BdTghC89H/h+e63D+q9mwh8dEewwlH/DjFer
         WI4UhOm9Xk61TWHOynnkKrscpt6iLD4S6hVHswJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Aayush Agarwal <aayush.a.agarwal@oracle.com>
Subject: [PATCH 4.4 09/14] phonet: refcount leak in pep_sock_accep
Date:   Mon, 10 Jan 2022 08:22:48 +0100
Message-Id: <20220110071812.079686737@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071811.779189823@linuxfoundation.org>
References: <20220110071811.779189823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit bcd0f93353326954817a4f9fa55ec57fb38acbb0 upstream.

sock_hold(sk) is invoked in pep_sock_accept(), but __sock_put(sk) is not
invoked in subsequent failure branches(pep_accept_conn() != 0).

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211209082839.33985-1-hbh25y@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Aayush Agarwal <aayush.a.agarwal@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -878,6 +878,7 @@ static struct sock *pep_sock_accept(stru
 
 	err = pep_accept_conn(newsk, skb);
 	if (err) {
+		__sock_put(sk);
 		sock_put(newsk);
 		newsk = NULL;
 		goto drop;


