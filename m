Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FE4123F7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379321AbhITS3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378881AbhITS0y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:26:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F1861262;
        Mon, 20 Sep 2021 17:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158760;
        bh=++P4j04yCqS3g1hj7do2i9wlBMgZSdq1e4y6ILLc2xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP9azl5Yh7paec3YBJzKbdvGwD107lXl8eZ8TfWfKIUuKLQvU8hXFf5BrbJA9Ggki
         WynZShcE7Q3y5A4RGvcKjzLB/D5FUafHElefVURd5oQyxLJqfROxxcvfXQ99MRnR4T
         qUyqx09qMfkHgtoipVYQzfGoiQiCEfZPMZb8c5kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Claudi <aclaudi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 043/122] selftest: net: fix typo in altname test
Date:   Mon, 20 Sep 2021 18:43:35 +0200
Message-Id: <20210920163917.199623037@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Claudi <aclaudi@redhat.com>

commit 1b704b27beb11ce147d64b21c914e57afbfb5656 upstream.

If altname deletion of the short alternative name fails, the error
message printed is: "Failed to add short alternative name".
This is obviously a typo, as we are testing altname deletion.

Fix this using a proper error message.

Fixes: f95e6c9c4617 ("selftest: net: add alternative names test")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/altnames.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/altnames.sh
+++ b/tools/testing/selftests/net/altnames.sh
@@ -45,7 +45,7 @@ altnames_test()
 	check_err $? "Got unexpected long alternative name from link show JSON"
 
 	ip link property del $DUMMY_DEV altname $SHORT_NAME
-	check_err $? "Failed to add short alternative name"
+	check_err $? "Failed to delete short alternative name"
 
 	ip -j -p link show $SHORT_NAME &>/dev/null
 	check_fail $? "Unexpected success while trying to do link show with deleted short alternative name"


