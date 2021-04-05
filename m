Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512F335407A
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240826AbhDEJSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239885AbhDEJSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:18:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC61A61399;
        Mon,  5 Apr 2021 09:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614280;
        bh=gt79QrYPFtr8VapyR20UI2g3woguhfoqsTW7aWmv72E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lc0aI8SbQPhYbGumyCLlQslE9lw6lJpGSNg7LtNrMYDxvHWT/kgbeqsqtFKHprTTf
         lbTmghs5BdT6sB3UG/CtiU5yvdUM1+eESw/31aD4VUrB46UMlucGIHL5guPz7ezmWN
         zv9pGQFXpiemnrwBtUTk7734PSqYBFuAcd52n6bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.11 104/152] pinctrl: qcom: fix unintentional string concatenation
Date:   Mon,  5 Apr 2021 10:54:13 +0200
Message-Id: <20210405085037.617290106@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 58b5ada8c465b5f1300bc021ebd3d3b8149124b4 upstream.

clang is clearly correct to point out a typo in a silly
array of strings:

drivers/pinctrl/qcom/pinctrl-sdx55.c:426:61: error: suspicious concatenation of string literals in an array initialization; did you mean to separate the elements with a comma? [-Werror,-Wstring-concatenation]
        "gpio14", "gpio15", "gpio16", "gpio17", "gpio18", "gpio19" "gpio20", "gpio21", "gpio22",
                                                                   ^
Add the missing comma that must have accidentally been removed.

Fixes: ac43c44a7a37 ("pinctrl: qcom: Add SDX55 pincontrol driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20210323131728.2702789-1-arnd@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-sdx55.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-sdx55.c
+++ b/drivers/pinctrl/qcom/pinctrl-sdx55.c
@@ -423,7 +423,7 @@ static const char * const gpio_groups[]
 
 static const char * const qdss_stm_groups[] = {
 	"gpio0", "gpio1", "gpio2", "gpio3", "gpio4", "gpio5", "gpio6", "gpio7", "gpio12", "gpio13",
-	"gpio14", "gpio15", "gpio16", "gpio17", "gpio18", "gpio19" "gpio20", "gpio21", "gpio22",
+	"gpio14", "gpio15", "gpio16", "gpio17", "gpio18", "gpio19", "gpio20", "gpio21", "gpio22",
 	"gpio23", "gpio44", "gpio45", "gpio52", "gpio53", "gpio56", "gpio57", "gpio61", "gpio62",
 	"gpio63", "gpio64", "gpio65", "gpio66",
 };


