Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737F1548E46
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbiFMKcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346516AbiFMKaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:30:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A2A21E30;
        Mon, 13 Jun 2022 03:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84D1EB80E93;
        Mon, 13 Jun 2022 10:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8A2C34114;
        Mon, 13 Jun 2022 10:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115679;
        bh=S2nyjzDsl6Qa9SKaZ1k8jiwAYyN6hsEchmkf/gZk/wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYRuPrOqFzSHvJNicUREVmj1n3y78i+rzobHmFxepfwGUIsDKg5bA/ySynEuNRPa/
         7bYvi+udlcwYTMcyXbzbK+3bp8wMIHWZ9Pl/EhU6TCzunmUhwkMzBmc0jh+b0zYBRH
         W1865mb90dYVt5YhQGf5GEepY4p22XM79nwnt5Gk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9 159/167] cifs: return errors during session setup during reconnects
Date:   Mon, 13 Jun 2022 12:10:33 +0200
Message-Id: <20220613094918.253916137@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 8ea21823aa584b55ba4b861307093b78054b0c1b upstream.

During reconnects, we check the return value from
cifs_negotiate_protocol, and have handlers for both success
and failures. But if that passes, and cifs_setup_session
returns any errors other than -EACCES, we do not handle
that. This fix adds a handler for that, so that we don't
go ahead and try a tree_connect on a failed session.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -265,6 +265,9 @@ smb2_reconnect(__le16 smb2_command, stru
 			rc = -EHOSTDOWN;
 			mutex_unlock(&tcon->ses->session_mutex);
 			goto failed;
+		} else if (rc) {
+			mutex_unlock(&ses->session_mutex);
+			goto out;
 		}
 	}
 	if (rc || !tcon->need_reconnect) {


