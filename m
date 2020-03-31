Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88690198FAF
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgCaJF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730381AbgCaJF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649ED20B1F;
        Tue, 31 Mar 2020 09:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645526;
        bh=6btdPEC8CzNBTP2CSMWFjhTl0NUxOV5Iz79NasmD+tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H7J9mk27pITMak2Se4AFbw8VZuRjgts4ew5J9run0Y13mk/gqKZgP02Uv4qon7Cty
         RDTPI1m0eQh4w4Ufm76QUg+uZlOVEttodZQB74inz2jze5VIW3RmTtExYO8elrYNlq
         RRoJ5r8YDTRjrPLbDZYP64Kvp8OaG5/Qxh6InYdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, stable@kernel.org
Subject: [PATCH 5.5 081/170] i2c: hix5hd2: add missed clk_disable_unprepare in remove
Date:   Tue, 31 Mar 2020 10:58:15 +0200
Message-Id: <20200331085432.922121941@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit e1b9f99ff8c40bba6e59de9ad4a659447b1e4112 upstream.

The driver forgets to disable and unprepare clk when remove.
Add a call to clk_disable_unprepare to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-hix5hd2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-hix5hd2.c
+++ b/drivers/i2c/busses/i2c-hix5hd2.c
@@ -477,6 +477,7 @@ static int hix5hd2_i2c_remove(struct pla
 	i2c_del_adapter(&priv->adap);
 	pm_runtime_disable(priv->dev);
 	pm_runtime_set_suspended(priv->dev);
+	clk_disable_unprepare(priv->clk);
 
 	return 0;
 }


