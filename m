Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C016FC50
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgBZKeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:34:00 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51029 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgBZKeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:34:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 71C0121AC2;
        Wed, 26 Feb 2020 05:33:59 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:33:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+nP+qH
        xLbtHn+b1BRyPHMRzSnKNxtstKuekFehs8BdQ=; b=rdY9vAcV73PmiXBDk8bAmQ
        7LQooLp2yCsdO57pcZGQk4gDxdT0EaNqzNEKMYNGGo6MJLcLrf8ngch70eXsBWsc
        VrQdo61jte+eWJu0aqyOzTmGklJdLeI3xPjO1QxASdWOGLbv/9oxtAzWjHjGwIvi
        G26NgpE6gK+spEGgUqE6o5oDGoh1sVlkJ5AbFvQkhQuWiekqAUDjlB3B0dl1es8k
        nDtlo0P6U9pymBHtrqzs2BvT7jn92oWLA5fS/qyR9wVeJFFffYdXIjmL3PphE/UR
        aO8DSAiMPKr2rGd7IvxvsvJZKD4+C0u87DDrAbe31eumTqfDFrwQEwemQkpOlYMw
        ==
X-ME-Sender: <xms:l0lWXiVxuv9GBXYnGrKn5at7ukhwtzpL1dqkUZ-byYixbCasMR6MaQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:l0lWXolZxd05ze9AQkgrV_9zzkdNpSCcsBSfLJEbg0aJDsB2-I-iVw>
    <xmx:l0lWXgc0lrZLrCtNU_UpDAT4f33wc0EueOpiQLT2v8eA6BUtpN7yKA>
    <xmx:l0lWXrFGaNOby9ektudXIEOWIGnlSAqIOq0MvYKYevRHx1EuzhbBhw>
    <xmx:l0lWXkjP7fWZEkcouHZPecrUMjNEVDd29u1nHCMR8WL6d9_HrQ_W7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D79FA30610E8;
        Wed, 26 Feb 2020 05:33:58 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/mce/amd: Publish the bank pointer only after setup has" failed to apply to 4.4-stable tree
To:     bp@suse.de, Saar.Amar@microsoft.com, dan.carpenter@oracle.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:33:55 +0100
Message-ID: <158271323545204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6e5cf31fbe651bed7ba1df768f2e123531132417 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Tue, 4 Feb 2020 13:28:41 +0100
Subject: [PATCH] x86/mce/amd: Publish the bank pointer only after setup has
 succeeded

threshold_create_bank() creates a bank descriptor per MCA error
thresholding counter which can be controlled over sysfs. It publishes
the pointer to that bank in a per-CPU variable and then goes on to
create additional thresholding blocks if the bank has such.

However, that creation of additional blocks in
allocate_threshold_blocks() can fail, leading to a use-after-free
through the per-CPU pointer.

Therefore, publish that pointer only after all blocks have been setup
successfully.

Fixes: 019f34fccfd5 ("x86, MCE, AMD: Move shared bank to node descriptor")
Reported-by: Saar Amar <Saar.Amar@microsoft.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200128140846.phctkvx5btiexvbx@kili.mountain

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index b3a50d962851..e7313e5c497c 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1198,8 +1198,9 @@ static const char *get_name(unsigned int bank, struct threshold_block *b)
 	return buf_mcatype;
 }
 
-static int allocate_threshold_blocks(unsigned int cpu, unsigned int bank,
-				     unsigned int block, u32 address)
+static int allocate_threshold_blocks(unsigned int cpu, struct threshold_bank *tb,
+				     unsigned int bank, unsigned int block,
+				     u32 address)
 {
 	struct threshold_block *b = NULL;
 	u32 low, high;
@@ -1243,16 +1244,12 @@ static int allocate_threshold_blocks(unsigned int cpu, unsigned int bank,
 
 	INIT_LIST_HEAD(&b->miscj);
 
-	if (per_cpu(threshold_banks, cpu)[bank]->blocks) {
-		list_add(&b->miscj,
-			 &per_cpu(threshold_banks, cpu)[bank]->blocks->miscj);
-	} else {
-		per_cpu(threshold_banks, cpu)[bank]->blocks = b;
-	}
+	if (tb->blocks)
+		list_add(&b->miscj, &tb->blocks->miscj);
+	else
+		tb->blocks = b;
 
-	err = kobject_init_and_add(&b->kobj, &threshold_ktype,
-				   per_cpu(threshold_banks, cpu)[bank]->kobj,
-				   get_name(bank, b));
+	err = kobject_init_and_add(&b->kobj, &threshold_ktype, tb->kobj, get_name(bank, b));
 	if (err)
 		goto out_free;
 recurse:
@@ -1260,7 +1257,7 @@ static int allocate_threshold_blocks(unsigned int cpu, unsigned int bank,
 	if (!address)
 		return 0;
 
-	err = allocate_threshold_blocks(cpu, bank, block, address);
+	err = allocate_threshold_blocks(cpu, tb, bank, block, address);
 	if (err)
 		goto out_free;
 
@@ -1345,8 +1342,6 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		goto out_free;
 	}
 
-	per_cpu(threshold_banks, cpu)[bank] = b;
-
 	if (is_shared_bank(bank)) {
 		refcount_set(&b->cpus, 1);
 
@@ -1357,9 +1352,13 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		}
 	}
 
-	err = allocate_threshold_blocks(cpu, bank, 0, msr_ops.misc(bank));
-	if (!err)
-		goto out;
+	err = allocate_threshold_blocks(cpu, b, bank, 0, msr_ops.misc(bank));
+	if (err)
+		goto out_free;
+
+	per_cpu(threshold_banks, cpu)[bank] = b;
+
+	return 0;
 
  out_free:
 	kfree(b);

