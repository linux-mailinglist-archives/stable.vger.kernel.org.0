Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389666C1797
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbjCTPPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjCTPO6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA6C49EA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:10:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 483FEB80EC0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFC4C4339B;
        Mon, 20 Mar 2023 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325003;
        bh=KU6C0BViPI5LkPsInh07pVx/7bCkN7O27OXrX0iH5WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHuQWtOyfbDtTS7rpPt8Z3ydTCN7OApsqbYr7wqVLV5o0em/yLRcy8hE49+Tr7+vU
         wQ1MaHNfFrjm12R0HawuuT6m+uEzGhMuh/m3MGd/GuZb7wdKidDGbAARobVOu+jemg
         K8lfNIA77xCZsw3YXFgN6y5eSWwNY+ZZeeJ99W0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jurica Vukadin <jura@vukad.in>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/115] kconfig: Update config changed flag before calling callback
Date:   Mon, 20 Mar 2023 15:54:31 +0100
Message-Id: <20230320145451.889982368@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jurica Vukadin <jura@vukad.in>

[ Upstream commit ee06a3ef7e3cddb62b90ac40aa661d3c12f7cabc ]

Prior to commit 5ee546594025 ("kconfig: change sym_change_count to a
boolean flag"), the conf_updated flag was set to the new value *before*
calling the callback. xconfig's save action depends on this behaviour,
because xconfig calls conf_get_changed() directly from the callback and
now sees the old value, thus never enabling the save button or the
shortcut.

Restore the previous behaviour.

Fixes: 5ee546594025 ("kconfig: change sym_change_count to a boolean flag")
Signed-off-by: Jurica Vukadin <jura@vukad.in>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 4a828bca071e8..797c8bad3837a 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1124,10 +1124,12 @@ static void (*conf_changed_callback)(void);
 
 void conf_set_changed(bool val)
 {
-	if (conf_changed_callback && conf_changed != val)
-		conf_changed_callback();
+	bool changed = conf_changed != val;
 
 	conf_changed = val;
+
+	if (conf_changed_callback && changed)
+		conf_changed_callback();
 }
 
 bool conf_get_changed(void)
-- 
2.39.2



