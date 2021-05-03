Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED0C37143A
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 13:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhECL0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:26:47 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:47662 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233247AbhECL0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 07:26:47 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 07:26:47 EDT
Date:   Mon, 03 May 2021 11:25:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620041151;
        bh=iqk/8OqDW+YHrtAwJMzgTJy4CwcJHEKFZWvNUBi7Cuk=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=RAVi046EBe6SPme3w1mEJTdzJByuDPziBM1wu6WfTdPt3zBEQ3UaRsB6t8+B0Llkj
         rFD4E4ufv6Yv9UaVuc2kn3IhIBMDcLHothCpal1s39TdQ7muy9oWukZLMicwwuuDfi
         JsxjkUc8kLowTSki7t7OSBR959eldWKIvMXiVSIw=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <A8fQ4ciWOpotsk0-AaomYWwrQyQjkL_UGglojY2GzTAcDqdYPPoS9vYVyBqqkVuS_VRm-gwhevo5o7f_ekWWHZNKNRG05I5oasdXSOd5DY0=@protonmail.com>
In-Reply-To: <YI6HFNNvzuHnv5VU@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org> <20210430141910.521897363@linuxfoundation.org> <608CFF6A.4BC054A3@users.sourceforge.net> <YI6HFNNvzuHnv5VU@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday, May 2, 2021 2:03 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.=
org> wrote:
> If you could provide backported patches to those kernels you think this
> is needed to, I can take them directly. Otherwise running sed isn't
> always the easiest thing to do on my end :)

iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_enqueue_hcmd()
upstream commit 2800aadc18a64c96b051bcb7da8a7df7d505db3f,
backport for linux-4.9.y (booted and ping tested)
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1510,6 +1510,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *tr=
ans,
 =09u32 cmd_pos;
 =09const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 =09u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
+=09unsigned long flags2;

 =09if (WARN(!trans->wide_cmd_header &&
 =09=09 group_id > IWL_ALWAYS_LONG_GROUP,
@@ -1593,10 +1594,10 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *=
trans,
 =09=09goto free_dup_buf;
 =09}

-=09spin_lock_bh(&txq->lock);
+=09spin_lock_irqsave(&txq->lock, flags2);

 =09if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-=09=09spin_unlock_bh(&txq->lock);
+=09=09spin_unlock_irqrestore(&txq->lock, flags2);

 =09=09IWL_ERR(trans, "No space in command queue\n");
 =09=09iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -1757,7 +1758,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *tr=
ans,
 =09spin_unlock_irqrestore(&trans_pcie->reg_lock, flags);

  out:
-=09spin_unlock_bh(&txq->lock);
+=09spin_unlock_irqrestore(&txq->lock, flags2);
  free_dup_buf:
 =09if (idx < 0)
 =09=09kfree(dup_buf);

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

