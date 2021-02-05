Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2886131151F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhBEWXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:23:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232500AbhBEO2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:28:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160946500F;
        Fri,  5 Feb 2021 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534250;
        bh=6J9ZmvFEAaG3oGT7LvaoN/qHHjKYIo5xf1ysxtlon+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SrTiQfe5pYXFCP1jhUjQZfv1rFvtIDi4l9ebg0jjGOCSenvJAlobmG2MypcH+78nc
         ed3UPoTME1xQ0z5r9ob5lV7eutOGzD18CfGrrBeHfOsfh+fdH8qzw1cg8d/Rxk0uIB
         L/X7ZwyL2G4LJ54R0OH6y9PY5//avcdgJN6IADpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/57] nvmet: set right status on error in id-ns handler
Date:   Fri,  5 Feb 2021 15:07:09 +0100
Message-Id: <20210205140657.824234483@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit bffcd507780ea614b5543c66f2e37ce0d55cd449 ]

The function nvmet_execute_identify_ns() doesn't set the status if call
to nvmet_find_namespace() fails. In that case we set the status of the
request to the value return by the nvmet_copy_sgl().

Set the status to NVME_SC_INVALID_NS and adjust the code such that
request will have the right status on nvmet_find_namespace() failure.

Without this patch :-
NVME Identify Namespace 3:
nsze    : 0
ncap    : 0
nuse    : 0
nsfeat  : 0
nlbaf   : 0
flbas   : 0
mc      : 0
dpc     : 0
dps     : 0
nmic    : 0
rescap  : 0
fpi     : 0
dlfeat  : 0
nawun   : 0
nawupf  : 0
nacwu   : 0
nabsn   : 0
nabo    : 0
nabspf  : 0
noiob   : 0
nvmcap  : 0
mssrl   : 0
mcl     : 0
msrc    : 0
nsattr	: 0
nvmsetid: 0
anagrpid: 0
endgid  : 0
nguid   : 00000000000000000000000000000000
eui64   : 0000000000000000
lbaf  0 : ms:0   lbads:0  rp:0 (in use)

With this patch-series :-
feb3b88b501e (HEAD -> nvme-5.11) nvmet: remove extra variable in identify ns
6302aa67210a nvmet: remove extra variable in id-desclist
ed57951da453 nvmet: remove extra variable in smart log nsid
be384b8c24dc nvmet: set right status on error in id-ns handler

NVMe status: INVALID_NS: The namespace or the format of that namespace is invalid(0xb)

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index dca34489a1dc9..92ca23bc8dbfc 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -487,8 +487,10 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 
 	/* return an all zeroed buffer if we can't find an active namespace */
 	ns = nvmet_find_namespace(ctrl, req->cmd->identify.nsid);
-	if (!ns)
+	if (!ns) {
+		status = NVME_SC_INVALID_NS;
 		goto done;
+	}
 
 	nvmet_ns_revalidate(ns);
 
@@ -541,7 +543,9 @@ static void nvmet_execute_identify_ns(struct nvmet_req *req)
 		id->nsattr |= (1 << 0);
 	nvmet_put_namespace(ns);
 done:
-	status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
+	if (!status)
+		status = nvmet_copy_to_sgl(req, 0, id, sizeof(*id));
+
 	kfree(id);
 out:
 	nvmet_req_complete(req, status);
-- 
2.27.0



