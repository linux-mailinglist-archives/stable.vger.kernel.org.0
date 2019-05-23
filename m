Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85ED28849
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390898AbfEWTY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390892AbfEWTY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:24:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E30C720868;
        Thu, 23 May 2019 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639465;
        bh=r0zyQ/B7KH52Fb9qpYaua23yoj2J/TXEHxufZ/7v2fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HdCu2P45Eovj4pDJqSykwE/khzv7mGw+9cjMYN9VCF6rh+imGp0paG0i4pn+g9J3Z
         j8urFBr1Pht5yBIw3PhyqTYUFFlv/GsfmI4Te7Qw5LzoitZl78gazH0WIL/owrj1OF
         rBrjNDN7L6j8w1khwMHUNN3OEufgs3HJ2FztxLSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yufen Yu <yuyufen@huawei.com>,
        Martin Wilck <mwilck@suse.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.0 098/139] dm mpath: always free attached_handler_name in parse_path()
Date:   Thu, 23 May 2019 21:06:26 +0200
Message-Id: <20190523181733.312916915@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

commit 940bc471780b004a5277c1931f52af363c2fc9da upstream.

Commit b592211c33f7 ("dm mpath: fix attached_handler_name leak and
dangling hw_handler_name pointer") fixed a memory leak for the case
where setup_scsi_dh() returns failure. But setup_scsi_dh may return
success and not "use" attached_handler_name if the
retain_attached_hwhandler flag is not set on the map. As setup_scsi_sh
properly "steals" the pointer by nullifying it, freeing it
unconditionally in parse_path() is safe.

Fixes: b592211c33f7 ("dm mpath: fix attached_handler_name leak and dangling hw_handler_name pointer")
Cc: stable@vger.kernel.org
Reported-by: Yufen Yu <yuyufen@huawei.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -882,6 +882,7 @@ static struct pgpath *parse_path(struct
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
+		kfree(attached_handler_name);
 		if (r) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
@@ -896,7 +897,6 @@ static struct pgpath *parse_path(struct
 
 	return p;
  bad:
-	kfree(attached_handler_name);
 	free_pgpath(p);
 	return ERR_PTR(r);
 }


