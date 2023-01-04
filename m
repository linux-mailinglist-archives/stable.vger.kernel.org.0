Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F70B65D88F
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239925AbjADQQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbjADQPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3B642E36
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FD03B81714
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FDFC433D2;
        Wed,  4 Jan 2023 16:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848927;
        bh=Kl5iSmtRJUndElxBOqXquGz9V0nuSOxCcm/TGlYEoXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmxEUKe9eCgnT1jZpFdm7puI9pXo/HfANJKzRyC/zM1BQRITXlYTxyq3WVbMNIIW2
         CvTeFS8ajklnywodIRn9ZaVRQ20g+65xaCzR4yHMKmRsS47rSJ5IVg0X7596/OpSRF
         6fHUmjez/a3LF7Qdv3ba02b3+2E7f7kKlQ6DRxnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 105/207] cifs: set correct tcon status after initial tree connect
Date:   Wed,  4 Jan 2023 17:06:03 +0100
Message-Id: <20230104160515.238171534@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit b248586a49a7729f73c504b1e7b958caea45e927 upstream.

cifs_tcon::status wasn't correctly updated to TID_GOOD after initial
tree connect thus staying at TID_NEW as long as it was connected.

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2602,6 +2602,7 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
+	tcon->status = TID_GOOD;
 
 	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,


