Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5995087E
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfFXKRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730986AbfFXKRc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:17:32 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B55B20645;
        Mon, 24 Jun 2019 10:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371451;
        bh=V2Etn4INr6GcwTyBxsWmtv+MQN/BvWi/3PnSnsAwPRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3/WzoPYtOVd+WtZh+eTfo/JKrNpjaMBtztkZOKS19UukW5zX0csu/uSybG3f+Lvl
         HWUSMEbtGFqWM8XigkO9TdcZply6fVHcGcH/YAyPO/hzKwLFoxJIYIdcU/eqOuq44a
         JkS6MvWxLnVnIbimv/ZyrKRqNHiCwPxDhTUTPgPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trevor Bourget <tgb.kernel@gmail.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 074/121] kbuild: tar-pkg: enable communication with jobserver
Date:   Mon, 24 Jun 2019 17:56:46 +0800
Message-Id: <20190624092324.685149388@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a6e0487709ded7cd1ba0c390d9771e5cb76a8453 ]

The buildtar script might want to invoke a make, so tell the parent
make to pass the jobserver token pipe to the subcommand by prefixing
the command with a +.

This addresses the issue seen here:

  /bin/sh ../scripts/package/buildtar tar-pkg
  make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.

See https://www.gnu.org/software/make/manual/html_node/Job-Slots.html
for more information.

Signed-off-by: Trevor Bourget <tgb.kernel@gmail.com>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 2c6de21e5152..fd854439de0f 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -103,7 +103,7 @@ clean-dirs += $(objtree)/snap/
 # ---------------------------------------------------------------------------
 tar%pkg: FORCE
 	$(MAKE) -f $(srctree)/Makefile
-	$(CONFIG_SHELL) $(srctree)/scripts/package/buildtar $@
+	+$(CONFIG_SHELL) $(srctree)/scripts/package/buildtar $@
 
 clean-dirs += $(objtree)/tar-install/
 
-- 
2.20.1



