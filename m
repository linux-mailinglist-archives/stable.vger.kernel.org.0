Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09DB656BC7
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 15:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiL0O2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 09:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiL0O2n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 09:28:43 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8277B6432;
        Tue, 27 Dec 2022 06:28:39 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.229])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4NhGzT0GwYz9xFGW;
        Tue, 27 Dec 2022 22:21:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.204.63.22])
        by APP2 (Coremail) with SMTP id GxC2BwAH3WP1AKtjzU5JAA--.42546S2;
        Tue, 27 Dec 2022 15:28:15 +0100 (CET)
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org
Cc:     linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v5 0/2] KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()
Date:   Tue, 27 Dec 2022 15:27:38 +0100
Message-Id: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GxC2BwAH3WP1AKtjzU5JAA--.42546S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw1UGF4xAry5CFy7CFyfJFb_yoWfArcEkF
        y8KasrXF18XF1IyFy2yF1kKry2krWDGr18KF18trWxZry3Kw1aqrsrWFWFvrWUXrs8AayU
        Gr15XryfJr9FgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb7AYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
        Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
        A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x02
        67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267
        AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
        j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
        kEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY
        0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcV
        CF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
        aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1rMa5UUUUU==
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQATBF1jj4cI0gADs5
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Sassu <roberto.sassu@huawei.com>

Changelog:

v4:
 - Replace sg_init_table()/sg_set_buf() with sg_init_one() (suggested by
   Eric)

v3:

v2:
 - Add patch by Herbert to take only the needed bytes for a MPI from the
   scatterlist
 - Use only one scatterlist for signature and digest (suggested by Eric)
 - Rename key variable to buf (suggested by Eric)
 - Rename key_max_len variable to buf_len
 - Use size_t for the buf_len variable instead of u32

v1:
 - Unconditionally copy the signature and digest to the buffer to keep the
   code simple (suggested by Eric)

Herbert Xu (1):
  lib/mpi: Fix buffer overrun when SG is too long

Roberto Sassu (1):
  KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()

 crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
 lib/mpi/mpicoder.c                  |  3 ++-
 2 files changed, 23 insertions(+), 18 deletions(-)

-- 
2.25.1

