Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6017333B7ED
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhCOOBo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232685AbhCON7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0F5164F1A;
        Mon, 15 Mar 2021 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816774;
        bh=5EHHy+RI8mq93sT8v8wO7Z8g+xB42XGaRZ8h7umuZbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8MiS2zsLGQZ4E7kd4VuBAxUxv05LoZBDThBI/Oi/ectpgwj5sqkBlN8dkFw5iOdr
         vT54vWzjOJ3AJ0Sd3Pa1TaNJhmIiKdsF3td/ATZaKbJN5DJSs4LXu58qWtOT1SbbkI
         j0Fj1558Mol/fzs0wgf1D257P9ANNerVl96IzH6g=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.10 107/290] cifs: fix credit accounting for extra channel
Date:   Mon, 15 Mar 2021 14:53:20 +0100
Message-Id: <20210315135545.522200360@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Aurelien Aptel <aaptel@suse.com>

commit a249cc8bc2e2fed680047d326eb9a50756724198 upstream.

With multichannel, operations like the queries
from "ls -lR" can cause all credits to be used and
errors to be returned since max_credits was not
being set correctly on the secondary channels and
thus the client was requesting 0 credits incorrectly
in some cases (which can lead to not having
enough credits to perform any operation on that
channel).

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
CC: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |   10 +++++-----
 fs/cifs/sess.c    |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2629,6 +2629,11 @@ smbd_connected:
 	tcp_ses->min_offload = volume_info->min_offload;
 	tcp_ses->tcpStatus = CifsNeedNegotiate;
 
+	if ((volume_info->max_credits < 20) || (volume_info->max_credits > 60000))
+		tcp_ses->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
+	else
+		tcp_ses->max_credits = volume_info->max_credits;
+
 	tcp_ses->nr_targets = 1;
 	tcp_ses->ignore_signature = volume_info->ignore_signature;
 	/* thread spawned, put it on the list */
@@ -4077,11 +4082,6 @@ static int mount_get_conns(struct smb_vo
 
 	*nserver = server;
 
-	if ((vol->max_credits < 20) || (vol->max_credits > 60000))
-		server->max_credits = SMB2_MAX_CREDITS_AVAILABLE;
-	else
-		server->max_credits = vol->max_credits;
-
 	/* get a reference to a SMB session */
 	ses = cifs_get_smb_ses(server, vol);
 	if (IS_ERR(ses)) {
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -224,6 +224,7 @@ cifs_ses_add_channel(struct cifs_ses *se
 	vol.noautotune = ses->server->noautotune;
 	vol.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	vol.echo_interval = ses->server->echo_interval / HZ;
+	vol.max_credits = ses->server->max_credits;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw


