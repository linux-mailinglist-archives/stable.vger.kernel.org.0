Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D108450F12
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbhKOS0C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:26:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241151AbhKOSYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91B4361B44;
        Mon, 15 Nov 2021 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998844;
        bh=8eSVBvHhEM/laQg3ggbIeciNRc3shP1+YqutuVyyj5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wo8f5uhTByB4ZW+VszYZsUnmKy3mEk4U5xjcWNfsn1HkDND31E5slI/q6+jif049v
         C4Hhi+ZswDDDhPFJlu8UoxIca8NM3RjFCWLysnCq0jPTkTAQ5hQ112E8YJY6HxbzF+
         clnCM0h2nrie8esuiA0RuZhLQOtfFVKBb7l/N26g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Meneghini <jmeneghi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 083/849] nvmet-tcp: fix a memory leak when releasing a queue
Date:   Mon, 15 Nov 2021 17:52:46 +0100
Message-Id: <20211115165422.867301687@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 926245c7d22271307606c88b1fbb2539a8550e94 ]

page_frag_free() won't completely release the memory
allocated for the commands, the cache page must be explicitly
freed by calling __page_frag_cache_drain().

This bug can be easily reproduced by repeatedly
executing the following command on the initiator:

$echo 1 > /sys/devices/virtual/nvme-fabrics/ctl/nvme0/reset_controller

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index d641bfa07a801..586ca20837e7b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1428,6 +1428,7 @@ static void nvmet_tcp_uninit_data_in_cmds(struct nvmet_tcp_queue *queue)
 
 static void nvmet_tcp_release_queue_work(struct work_struct *w)
 {
+	struct page *page;
 	struct nvmet_tcp_queue *queue =
 		container_of(w, struct nvmet_tcp_queue, release_work);
 
@@ -1447,6 +1448,8 @@ static void nvmet_tcp_release_queue_work(struct work_struct *w)
 		nvmet_tcp_free_crypto(queue);
 	ida_simple_remove(&nvmet_tcp_queue_ida, queue->idx);
 
+	page = virt_to_head_page(queue->pf_cache.va);
+	__page_frag_cache_drain(page, queue->pf_cache.pagecnt_bias);
 	kfree(queue);
 }
 
-- 
2.33.0



