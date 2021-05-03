Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFD3371440
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 13:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhECL2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:28:48 -0400
Received: from mail-41104.protonmail.ch ([185.70.41.104]:56896 "EHLO
        mail-41104.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhECL2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 07:28:48 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 07:28:47 EDT
Received: from mail-02.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41104.protonmail.ch (Postfix) with ESMTPS id 4FYgWk2zB9z4x778
        for <stable@vger.kernel.org>; Mon,  3 May 2021 11:20:50 +0000 (UTC)
Authentication-Results: mail-41104.protonmail.ch;
        dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="O869RQ1Y"
Date:   Mon, 03 May 2021 11:20:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620040846;
        bh=rrcJr6SHky9qwolfSD/uvxO1zmBQLEYyXaaRXq0xJMM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=O869RQ1Y8p0efGFoCzzyAoZ7P3+j0wCaD8Uaete2hUpvlnLyghIuy/scmvCBdSPiy
         ZeIYYOItlr/v/ptlhrN5OOF0g0fhzaA8aES8YvjvRcsmuKkj9jrzwLN7oFVY9nbJw/
         K6Byhq4U2OlivPeZytmge4N+gIH1xeDSFlTRlx0c=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <d-jJSpscDSj6GA3x0-9RE6fw-WaW7STDw46NzOgJ684IokIkyXNoZsR5xqNHZA7cpS81_MFvhvBzIoI_QGTbT5Im-CKI_AAp6fNzVfc8LX8=@protonmail.com>
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
backport for linux-5.4.y and linux-4.19.y (booted and ping tested)
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1544,6 +1544,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *tr=
ans,
 =09u32 cmd_pos;
 =09const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 =09u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
+=09unsigned long flags2;

 =09if (WARN(!trans->wide_cmd_header &&
 =09=09 group_id > IWL_ALWAYS_LONG_GROUP,
@@ -1627,10 +1628,10 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *=
trans,
 =09=09goto free_dup_buf;
 =09}

-=09spin_lock_bh(&txq->lock);
+=09spin_lock_irqsave(&txq->lock, flags2);

 =09if (iwl_queue_space(trans, txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-=09=09spin_unlock_bh(&txq->lock);
+=09=09spin_unlock_irqrestore(&txq->lock, flags2);

 =09=09IWL_ERR(trans, "No space in command queue\n");
 =09=09iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -1791,7 +1792,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *tr=
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

