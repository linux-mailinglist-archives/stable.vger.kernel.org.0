Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F86C18EE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbjCTP3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjCTP2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343A632529
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EEB4B80EC1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4D0C4339E;
        Mon, 20 Mar 2023 15:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325693;
        bh=YBvbrQJEaEy8jM6jUSRjD/yFZkav/5OEu3lkUQKcoHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFYcgewC8V8thaRu4cTyHoEAZAD4Gqg9bliGv4L5tRj85W5AcCeIMloJmhBHV1pin
         zeR6dxmTeqceyWkbSYiNgGMfGdcv5KzQsGzebBbsgEzTs1GfK99HKS+JkNqKe5Nbff
         e785/K4BP1VSo5UyMmt83oxXVWUWcbtzHR414jXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jurica Vukadin <jura@vukad.in>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/198] kconfig: Update config changed flag before calling callback
Date:   Mon, 20 Mar 2023 15:53:57 +0100
Message-Id: <20230320145511.725551611@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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
index b7c9f1dd5e422..992575f1e9769 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1226,10 +1226,12 @@ static void (*conf_changed_callback)(void);
 
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



