Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280BE37144B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 13:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhECLds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:33:48 -0400
Received: from mail-41104.protonmail.ch ([185.70.41.104]:40362 "EHLO
        mail-41104.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhECLdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 May 2021 07:33:47 -0400
Received: from mail-02.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        by mail-41104.protonmail.ch (Postfix) with ESMTPS id 4FYgc714Cvz4x77Q
        for <stable@vger.kernel.org>; Mon,  3 May 2021 11:24:39 +0000 (UTC)
Authentication-Results: mail-41104.protonmail.ch;
        dkim=pass (1024-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="HKewWEQz"
Date:   Mon, 03 May 2021 11:24:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620041075;
        bh=9UXyWCdtFSkJZax5maw9HnHOgssZdFyvowptmsDe79Y=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=HKewWEQzAB1VlBPqUoV/Cuu3cDRyF49fbINUvmPkqzlb9XLSXIHYwlnV4HViLFrYx
         o1TvS4KBBvb9B2gA7v36bxO9JsDudyAI71HoswQpQ+FCQlOtlO5hLU6HHk4XH2Whe+
         3vIUEfSRsaoo9o7bJuZPLw+qwoZ8Y1fLv3i8LOSs=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <4BUKMSXHCxdszAAqg0fhlp77qyGktcvj5tcuXiz3_u__YOPqm8QSyOHtGeTy8xiaB4LGC0xJ6EA89l_uI5nZyLmWe_0ugkSFavmWEQbQGDU=@protonmail.com>
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

iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e,
backport for linux-4.14.y (booted and ping tested)
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -559,6 +559,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans =
*trans,
 =09const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 =09u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 =09struct iwl_tfh_tfd *tfd =3D iwl_pcie_get_tfd(trans, txq, txq->write_ptr=
);
+=09unsigned long flags2;

 =09memset(tfd, 0, sizeof(*tfd));

@@ -629,10 +630,10 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_tran=
s *trans,
 =09=09goto free_dup_buf;
 =09}

-=09spin_lock_bh(&txq->lock);
+=09spin_lock_irqsave(&txq->lock, flags2);

 =09if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-=09=09spin_unlock_bh(&txq->lock);
+=09=09spin_unlock_irqrestore(&txq->lock, flags2);

 =09=09IWL_ERR(trans, "No space in command queue\n");
 =09=09iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -773,7 +774,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans =
*trans,
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

