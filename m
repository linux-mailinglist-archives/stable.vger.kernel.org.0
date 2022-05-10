Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9AF5219F1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiEJNwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343557AbiEJNsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:48:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6CF2B09C2;
        Tue, 10 May 2022 06:36:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EC52B81DAF;
        Tue, 10 May 2022 13:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E9CC385C2;
        Tue, 10 May 2022 13:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189787;
        bh=ztsU5dmS7toICJwPpwBvhqBZNz9WAcj48WoOreS6KZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUUL8Uf6ttUy6gaySFWo1qgWnHU0FEJ/5yXsGk6MiFIdstvGuzA3tLBhaOqZU76zC
         8qp31xNCgOnhAMDo1SUN5O3WlPCkkXymnHL2VgQt0OHls4lyiALFBD1jjoS7vOLbdH
         0CirNWZAqw2p3h0kxPOpUztiyH3vfHyimWdvOndk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.17 028/140] btrfs: sysfs: export the balance paused state of exclusive operation
Date:   Tue, 10 May 2022 15:06:58 +0200
Message-Id: <20220510130742.417556860@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit 3e1ad196385c65c1454aceab1226d9a4baca27d5 upstream.

The new state allowing device addition with paused balance is not
exported to user space so it can't recognize it and actually start the
operation.

Fixes: efc0e69c2fea ("btrfs: introduce exclusive operation BALANCE_PAUSED state")
CC: stable@vger.kernel.org # 5.17
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -919,6 +919,9 @@ static ssize_t btrfs_exclusive_operation
 		case BTRFS_EXCLOP_BALANCE:
 			str = "balance\n";
 			break;
+		case BTRFS_EXCLOP_BALANCE_PAUSED:
+			str = "balance paused\n";
+			break;
 		case BTRFS_EXCLOP_DEV_ADD:
 			str = "device add\n";
 			break;


