Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62112171EA
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgGGP0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgGGP0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:26:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601C120663;
        Tue,  7 Jul 2020 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135607;
        bh=uvUxeg5vGzn6yKdbuMh3DQpaC5PknltZCRUPvJQsp+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+r3+yjlXFulr3SbyRyzKCTQny4QPkKAe2gKqv9y7FF0oIHuT4zMtN2Gp4iSfqKHM
         zrsDe318RUdPS96srCerjLE2oAtC/CAtecEPc62L4PPfPd/5haJsADD1+Bbp/ktPDK
         fcM6jJAuRQN+ukgis9iTj7AlcVh0gco+PyUlW5pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.7 090/112] SMB3: Honor persistent/resilient handle flags for multiuser mounts
Date:   Tue,  7 Jul 2020 17:17:35 +0200
Message-Id: <20200707145805.260448796@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

commit 00dfbc2f9c61185a2e662f27c45a0bb29b2a134f upstream.

Without this:

- persistent handles will only be enabled for per-user tcons if the
  server advertises the 'Continuous Availabity' capability
- resilient handles would never be enabled for per-user tcons

Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5306,6 +5306,8 @@ cifs_construct_tcon(struct cifs_sb_info
 	vol_info->nocase = master_tcon->nocase;
 	vol_info->nohandlecache = master_tcon->nohandlecache;
 	vol_info->local_lease = master_tcon->local_lease;
+	vol_info->resilient = master_tcon->use_resilient;
+	vol_info->persistent = master_tcon->use_persistent;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 	vol_info->linux_ext = master_tcon->posix_extensions;
 	vol_info->sectype = master_tcon->ses->sectype;


