Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F86353D3E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhDEI7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhDEI7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:59:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1CF06138A;
        Mon,  5 Apr 2021 08:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613149;
        bh=E9fku5e4yUEvAUCCP0/vErZNYjwJokpzyYfd/zqTwu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TGTwiVZxfaAtWjtw1lL2r9OVfs8y/fIGgiFni18298n1M+E/9bo4M9+GIsodj0Tb1
         fXDBwS8PlZQy0nvJUPuduLa0OEgA4sJZvybZuEMYBvMrbHG6v+W2XPbkfuQQCiJwcy
         aZsb+neRlvC+3B7glzJrcA1v4G6wXqv4T+gcxtZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 38/52] extcon: Add stubs for extcon_register_notifier_all() functions
Date:   Mon,  5 Apr 2021 10:54:04 +0200
Message-Id: <20210405085023.227582602@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085021.996963957@linuxfoundation.org>
References: <20210405085021.996963957@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit c9570d4a5efd04479b3cd09c39b571eb031d94f4 ]

Add stubs for extcon_register_notifier_all() function for !CONFIG_EXTCON
case.  This is useful for compile testing and for drivers which use
EXTCON but do not require it (therefore do not depend on CONFIG_EXTCON).

Fixes: 815429b39d94 ("extcon: Add new extcon_register_notifier_all() to monitor all external connectors")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/extcon.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 744d60ca80c3..8f4dc784ab90 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -377,6 +377,29 @@ static inline  void devm_extcon_unregister_notifier(struct device *dev,
 				struct extcon_dev *edev, unsigned int id,
 				struct notifier_block *nb) { }
 
+static inline int extcon_register_notifier_all(struct extcon_dev *edev,
+					       struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int extcon_unregister_notifier_all(struct extcon_dev *edev,
+						 struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int devm_extcon_register_notifier_all(struct device *dev,
+						    struct extcon_dev *edev,
+						    struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline void devm_extcon_unregister_notifier_all(struct device *dev,
+						       struct extcon_dev *edev,
+						       struct notifier_block *nb) { }
+
 static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
 	return ERR_PTR(-ENODEV);
-- 
2.30.2



