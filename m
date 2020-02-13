Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EEEA15C5BF
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgBMPY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgBMPY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:26 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF26824689;
        Thu, 13 Feb 2020 15:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607466;
        bh=FxYiCaXQskh90KrwG3iV7GTqM8cjabD5+J+amsqs1UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=POH54u7Vr79CHJl7fGsj9PiBOiU9VnNHlV4XCWj74sCtITXqGfCpT2LEULk8fu01y
         EH/EIj5crObIh5NL+z5pa5Ksls0jVXRrFXjFQK+t9M0Y3lagttU/SBu0E98P2OPYW1
         KP66uN+s4T/Azpjw8mqwZvBTcwr7AUsRRrX3q2ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.9 101/116] nfs: NFS_SWAP should depend on SWAP
Date:   Thu, 13 Feb 2020 07:20:45 -0800
Message-Id: <20200213151921.815202739@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 474c4f306eefbb21b67ebd1de802d005c7d7ecdc upstream.

If CONFIG_SWAP=n, it does not make much sense to offer the user the
option to enable support for swapping over NFS, as that will still fail
at run time:

    # swapon /swap
    swapon: /swap: swapon failed: Function not implemented

Fix this by adding a dependency on CONFIG_SWAP.

Fixes: a564b8f0398636ba ("nfs: enable swap on NFS")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -89,7 +89,7 @@ config NFS_V4
 config NFS_SWAP
 	bool "Provide swap over NFS support"
 	default n
-	depends on NFS_FS
+	depends on NFS_FS && SWAP
 	select SUNRPC_SWAP
 	help
 	  This option enables swapon to work on files located on NFS mounts.


