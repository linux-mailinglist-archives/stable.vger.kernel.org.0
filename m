Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71D74B4C5F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348897AbiBNKki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:40:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348906AbiBNKkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:40:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DC840A3B;
        Mon, 14 Feb 2022 02:04:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40578B80DA6;
        Mon, 14 Feb 2022 10:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBE2C340E9;
        Mon, 14 Feb 2022 10:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644833031;
        bh=fkDalG/b6PGqzj6WaVb4J36Ptr1/KBf8bM9KnaprYO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVcMV0G+hcjOzJfalCmi41onq/lbTEWVDdqxszH14utjHeGAB3/3iBpfgRClVOJQW
         AQGA0RXllpg+KaczGryYYVMDv5cDVHa63A/w772RbyqmVqMDskkCs5/mpL8dfRtbjK
         NKcI/YlFDV0rYW2qhJTlbEYB9C4krFxwDSZ7+RLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryan Cai <ycaibb@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.16 201/203] kconfig: fix missing fclose() on error paths
Date:   Mon, 14 Feb 2022 10:27:25 +0100
Message-Id: <20220214092517.204082731@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit d23a0c3718222a42430fd56359478a6fc7675070 upstream.

The file is not closed when ferror() fails.

Fixes: 00d674cb3536 ("kconfig: refactor conf_write_dep()")
Fixes: 57ddd07c4560 ("kconfig: refactor conf_write_autoconf()")
Reported-by: Ryan Cai <ycaibb@gmail.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/kconfig/confdata.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -977,10 +977,10 @@ static int conf_write_autoconf_cmd(const
 
 	fprintf(out, "\n$(deps_config): ;\n");
 
-	if (ferror(out)) /* error check for all fprintf() calls */
-		return -1;
-
+	ret = ferror(out); /* error check for all fprintf() calls */
 	fclose(out);
+	if (ret)
+		return -1;
 
 	if (rename(tmp, name)) {
 		perror("rename");
@@ -1091,10 +1091,10 @@ static int __conf_write_autoconf(const c
 			print_symbol(file, sym);
 
 	/* check possible errors in conf_write_heading() and print_symbol() */
-	if (ferror(file))
-		return -1;
-
+	ret = ferror(file);
 	fclose(file);
+	if (ret)
+		return -1;
 
 	if (rename(tmp, filename)) {
 		perror("rename");


