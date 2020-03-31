Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6F9198FB3
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731012AbgCaJFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:05:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgCaJFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:05:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B07120B80;
        Tue, 31 Mar 2020 09:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645532;
        bh=eTsrk4rS2oByHAz2G34KbqfNarKNhRueHXowZf1Awo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DUblurlyG+tcG3+W0+6KPmfCK0nhZvc+Eh4RGS1xxjHZp01BYZ6/UbjYikSSzqa41
         X7193yhnit7f4cvwq6c/gC3WKuS/Ms019XJIKxQLgkaAPW+vv4oYTQJBXaYDnEmcxg
         WcGkSIXTZPi1N4xfkl8HX5fziors5R/aNKAjGwk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, teika kazura <teika@gmx.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.5 083/170] Input: fix stale timestamp on key autorepeat events
Date:   Tue, 31 Mar 2020 10:58:17 +0200
Message-Id: <20200331085433.125640559@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 4134252ab7e2c339a54302b88496cb5a89cdbaec upstream.

We need to refresh timestamp when emitting key autorepeat events, otherwise
they will carry timestamp of the original key press event.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206929
Fixes: 3b51c44bd693 ("Input: allow drivers specify timestamp for input events")
Cc: stable@vger.kernel.org
Reported-by: teika kazura <teika@gmx.com>
Tested-by: teika kazura <teika@gmx.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/input.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -190,6 +190,7 @@ static void input_repeat_key(struct time
 			input_value_sync
 		};
 
+		input_set_timestamp(dev, ktime_get());
 		input_pass_values(dev, vals, ARRAY_SIZE(vals));
 
 		if (dev->rep[REP_PERIOD])


