Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C9C431EC7
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhJROFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234795AbhJROC4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:02:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B628361A59;
        Mon, 18 Oct 2021 13:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564603;
        bh=9pu9bCzrkzvnXahF8HG3r/5hRxwLV8WZqkBLM5MNi2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTzEfIZd2R76YpwIdY8UiHTnEMHBnpTb3PlWSZ0wJn6Cy057lRi5CHzxtWTcxXcIT
         Y82V/Si7u2gQHSr9fpuHh1HuRD3kpUTd6IAZYwLVx9QMiO3K9d3DtgMp+A/StkYtYt
         rSzbtNrAo1ECiNcjlB3oEkqg+hecZz91jQ3XjwEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 140/151] qed: Fix missing error code in qed_slowpath_start()
Date:   Mon, 18 Oct 2021 15:25:19 +0200
Message-Id: <20211018132345.210751418@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

commit a5a14ea7b4e55604acb0dc9d88fdb4cb6945bc77 upstream.

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc'.

Eliminate the follow smatch warning:

drivers/net/ethernet/qlogic/qed/qed_main.c:1298 qed_slowpath_start()
warn: missing error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: d51e4af5c209 ("qed: aRFS infrastructure support")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1295,6 +1295,7 @@ static int qed_slowpath_start(struct qed
 			} else {
 				DP_NOTICE(cdev,
 					  "Failed to acquire PTT for aRFS\n");
+				rc = -EINVAL;
 				goto err;
 			}
 		}


