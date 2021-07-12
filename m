Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010223C5434
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347839AbhGLH5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345831AbhGLHxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE50D60200;
        Mon, 12 Jul 2021 07:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076235;
        bh=uORgVOhzNGGZCLGMKlrf9wbnUnEkU696nU2JeLpdqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOHatnkhivnRc+J71p0WKqEfe2DIWIJG+t3YeZyes/BkfyapNmwQ3lifJL/h3lXEb
         q+qge0Fn4P2ipUNUbOLR0vsaQVF7Hl+s/L26p9ahqRe1r+T90ngVy0ch7VwzXpQcM6
         e9wvT9eBqeasVm4sL+FPL+bWRxouCFF1mY69Q2xo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 555/800] can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0
Date:   Mon, 12 Jul 2021 08:09:38 +0200
Message-Id: <20210712061026.431944110@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

[ Upstream commit aaf473d0100f64abc88560e2bea905805bcf2a8e ]

If optval != NULL and optlen == 0 are specified for SO_J1939_FILTER in
j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0
size allocation. The new filter will be mistakenly assigned ZERO_PTR.
This patch checks for optlen != 0 and filter will be assigned NULL in
case of optlen == 0.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/20210620123842.117975-1-nslusarek@gmx.net
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/j1939/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index fce8bc8afeb7..e1a399821238 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -676,7 +676,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case SO_J1939_FILTER:
-		if (!sockptr_is_null(optval)) {
+		if (!sockptr_is_null(optval) && optlen != 0) {
 			struct j1939_filter *f;
 			int c;
 
-- 
2.30.2



