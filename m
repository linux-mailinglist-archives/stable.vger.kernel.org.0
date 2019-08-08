Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05ABA86A33
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404567AbfHHTIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404553AbfHHTIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE0ED2173E;
        Thu,  8 Aug 2019 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291323;
        bh=TiuuaJ36C3Tq9Pudb/TOeT57HjoTagvIE+dUO1OcGLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiG1uWd5wPVFQCy0WARybNyNP3nCua3INJ1YboAy3XoNIxsRkAstAhhOW4ZTJ8aaH
         i5xCb2RBSxSlodarFcTsa0II38NgSDHo0Aa/SvHk18vTdBGCFoXb6ZMZgHSkDdZsG0
         f40dANrMADEK6VmU2Ac/kIpa61onPYmUdZLNkgSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 02/45] gcc-9: dont warn about uninitialized variable
Date:   Thu,  8 Aug 2019 21:04:48 +0200
Message-Id: <20190808190453.957626304@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit cf676908846a06443fa5e6724ca3f5dd7460eca1 upstream.

I'm not sure what made gcc warn about this code now.  The 'ret' variable
does end up initialized in all cases, but it's definitely not obvious,
so the compiler is quite reasonable to warn about this.

So just add initialization to make it all much more obvious both to
compilers and to humans.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/i2c-core-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core-base.c
+++ b/drivers/i2c/i2c-core-base.c
@@ -185,7 +185,7 @@ static int i2c_generic_bus_free(struct i
 int i2c_generic_scl_recovery(struct i2c_adapter *adap)
 {
 	struct i2c_bus_recovery_info *bri = adap->bus_recovery_info;
-	int i = 0, scl = 1, ret;
+	int i = 0, scl = 1, ret = 0;
 
 	if (bri->prepare_recovery)
 		bri->prepare_recovery(adap);


