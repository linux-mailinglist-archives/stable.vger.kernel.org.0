Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5495B6ECE5C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjDXNbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjDXNbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096E97AB6
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:31:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8C136233C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92C9C433EF;
        Mon, 24 Apr 2023 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343059;
        bh=F0xo3TK4nFYyr291iZuMfIYFpoQphmclRzYN+rsUH/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waO10aZSNrjcetGHgduVGvGqyMaETpeoQUavMZirY3LIuaLF2QshsLe6jasikwlDC
         nzpVmSkvanCkuAhJLr21qEB/GaLdD9VCOE70qtpniM+RQlxICtCbThJsiCKtz97vA5
         ngdLFDRmw9UaYLLbXDugWHhaDUNBbD0zGrN0ecwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Boris Burkov <boris@bur.io>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 6.2 060/110] btrfs: set default discard iops_limit to 1000
Date:   Mon, 24 Apr 2023 15:17:22 +0200
Message-Id: <20230424131138.552705731@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Burkov <boris@bur.io>

commit e9f59429b87d35cf23ae9ca19629bd686a1c0304 upstream.

Previously, the default was a relatively conservative 10. This results
in a 100ms delay, so with ~300 discards in a commit, it takes the full
30s till the next commit to finish the discards. On a workstation, this
results in the disk never going idle, wasting power/battery, etc.

Set the default to 1000, which results in using the smallest possible
delay, currently, which is 1ms. This has shown to not pathologically
keep the disk busy by the original reporter.

Link: https://lore.kernel.org/linux-btrfs/Y%2F+n1wS%2F4XAH7X1p@nz/
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2182228
CC: stable@vger.kernel.org # 6.2+
Reviewed-by: Neal Gompa <neal@gompa.dev
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/discard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -60,7 +60,7 @@
 #define BTRFS_DISCARD_TARGET_MSEC	(6 * 60 * 60UL * MSEC_PER_SEC)
 #define BTRFS_DISCARD_MIN_DELAY_MSEC	(1UL)
 #define BTRFS_DISCARD_MAX_DELAY_MSEC	(1000UL)
-#define BTRFS_DISCARD_MAX_IOPS		(10U)
+#define BTRFS_DISCARD_MAX_IOPS		(1000U)
 
 /* Monotonically decreasing minimum length filters after index 0 */
 static int discard_minlen[BTRFS_NR_DISCARD_LISTS] = {


