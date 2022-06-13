Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA29654890C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355713AbiFMLtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357594AbiFMLq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:46:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB68735A95;
        Mon, 13 Jun 2022 03:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 498B0B80D3C;
        Mon, 13 Jun 2022 10:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6BAC34114;
        Mon, 13 Jun 2022 10:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117572;
        bh=bbS3wuB1ht8HYgjkKW2/j30gkkPXpposdmaDu83bLEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvAC2+uFYF2x2+vdtDD2y5zQ6o30aaGW9N5FtIzVTJ2eOCZVkLpvXKL2jXFxNPYAE
         gzmlSeZyukRDBPq4opw1I4DyyLsGoO0oMEMWzlGWYZ6fyDXjrkqaGsvpPC2RLe55pa
         bu0WsisrdCsxcUVTg//F6+MmFrkIjyrC3+yg2eFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 401/411] cifs: return errors during session setup during reconnects
Date:   Mon, 13 Jun 2022 12:11:14 +0200
Message-Id: <20220613094940.849534536@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
@@ -356,6 +356,9 @@ smb2_reconnect(__le16 smb2_command, stru
 			rc = -EHOSTDOWN;
 			mutex_unlock(&tcon->ses->session_mutex);
 			goto failed;
+		} else if (rc) {
+			mutex_unlock(&ses->session_mutex);
+			goto out;
 		}
 	}
 	if (rc || !tcon->need_reconnect) {


