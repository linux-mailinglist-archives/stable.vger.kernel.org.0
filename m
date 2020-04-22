Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5381B3D75
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728876AbgDVKPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgDVKPA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 348922075A;
        Wed, 22 Apr 2020 10:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550499;
        bh=iXMXhubN516VSHJjbodtOZrbU9W45/hHHrxQFuVpNxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgP0pDM5sqZAsc8G9kVhenEjjrQDot/x018AjeqoRqC5O8Ey7edKnTUEAKMhhOy3P
         JKeJp1xNReM+yvaUHNNEYNCqieclOVRaAHgxsSbfDvj2vT37HuKU2dETklfsKlA3ar
         p5VFlDhU18BiEcXqmcnLZ42jyzIcvnQGc+nr6478=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.19 14/64] of: overlay: kmemleak in dup_and_fixup_symbol_prop()
Date:   Wed, 22 Apr 2020 11:56:58 +0200
Message-Id: <20200422095015.374331228@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Rowand <frank.rowand@sony.com>

commit 478ff649b1c8eb2409b1a54fb75eb46f7c29f140 upstream.

kmemleak reports several memory leaks from devicetree unittest.
This is the fix for problem 4 of 5.

target_path was not freed in the non-error path.

Fixes: e0a58f3e08d4 ("of: overlay: remove a dependency on device node full_name")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/overlay.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -261,6 +261,8 @@ static struct property *dup_and_fixup_sy
 
 	of_property_set_flag(new_prop, OF_DYNAMIC);
 
+	kfree(target_path);
+
 	return new_prop;
 
 err_free_new_prop:


