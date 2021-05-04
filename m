Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E358372EDA
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhEDRZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:25:38 -0400
Received: from mail-40138.protonmail.ch ([185.70.40.138]:38868 "EHLO
        mail-40138.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhEDRZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 13:25:38 -0400
X-Greylist: delayed 108008 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 13:25:37 EDT
Date:   Tue, 04 May 2021 17:24:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620149081;
        bh=4VXUpqUkQHnQnHXSQVZldgHqnsafUJMYO36/7cP3I44=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=eSbIrYpHihhLoFfhYrocltw8AKCHo97bh2r4Av2mubvrcDvjOoVifAQkLJ5uX/OLy
         uBgSoaqTz+RHbOuc7uOOR3rfFacSpmAHpgCX4yF3+kceituh8tIyETgGVAHYLFp84r
         8ekwY8CWO7GDhYecsIPmY3NclDVDz1eOv88KBHLc=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Backport for 5.4 and 4.19, iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <E086D-ihTz8oxFCOfQojcsu3VO58JvDu-mjy-aXhRSgqf2BfyAm-YD5ZKQBbvt0yQOFbGKzf9vtUWGTtNX5qPLNboxTBcUT2mmaEagFCR4Q=@protonmail.com>
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

iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
upstream commit e7020bb068d8be50a92f48e36b236a1a1ef9282e,
backport for linux-5.4.y and linux-4.19.y (booted and ping tested)
Signed-off-by: Jari Ruusu <jariruusu@protonmail.com>

--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -705,6 +705,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans =
*trans,
 =09const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 =09u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 =09struct iwl_tfh_tfd *tfd;
+=09unsigned long flags2;

 =09copy_size =3D sizeof(struct iwl_cmd_header_wide);
 =09cmd_size =3D sizeof(struct iwl_cmd_header_wide);
@@ -773,14 +774,14 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_tran=
s *trans,
 =09=09goto free_dup_buf;
 =09}

-=09spin_lock_bh(&txq->lock);
+=09spin_lock_irqsave(&txq->lock, flags2);

 =09idx =3D iwl_pcie_get_cmd_index(txq, txq->write_ptr);
 =09tfd =3D iwl_pcie_get_tfd(trans, txq, txq->write_ptr);
 =09memset(tfd, 0, sizeof(*tfd));

 =09if (iwl_queue_space(trans, txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-=09=09spin_unlock_bh(&txq->lock);
+=09=09spin_unlock_irqrestore(&txq->lock, flags2);

 =09=09IWL_ERR(trans, "No space in command queue\n");
 =09=09iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -915,7 +916,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans =
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

