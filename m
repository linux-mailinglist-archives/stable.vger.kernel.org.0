Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A8C372E64
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 19:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhEDRD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 13:03:26 -0400
Received: from mail-0301.mail-europe.com ([188.165.51.139]:48279 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231887AbhEDRD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 13:03:26 -0400
X-Greylist: delayed 106747 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 13:03:26 EDT
Date:   Tue, 04 May 2021 17:02:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620147744;
        bh=CbdmEmk9lb2MgsVE9gcAhnwdCS6ANCEre4YEOrrImEc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=J5Gmq2mvoNiC01lFzHpqRWn07ajMaBMEbZffDpZaDKUpLWQebw0cvFxK/02vfNsYV
         JMwjNXsKV1K8I9klLdWLVC+UveZNOAxpjaraKj9Ne3xvjD3b+nX4BJTTas6X+0DyvO
         IW+Fn+6pC7iVhUFKcZMZn+zFI0xG16XHXaU+Id8g=
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Kalle Valo <kvalo@codeaurora.org>
Reply-To: Jari Ruusu <jariruusu@protonmail.com>
Subject: Re: [PATCH 5.10 1/2] iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
Message-ID: <lKQ4w6tXpon1sVWKDLQXCcZLzvchbrKBCQPO83v1wu9e-Ewul20hGjbfcOX1GeqFYhQGWpBV7GiyPM13lnU0BE3A9D11OEYt-_g_HwcCyQI=@protonmail.com>
In-Reply-To: <YJFpxY6iFHMiPHFE@kroah.com>
References: <20210430141910.473289618@linuxfoundation.org> <20210430141910.521897363@linuxfoundation.org> <608CFF6A.4BC054A3@users.sourceforge.net> <YI6HFNNvzuHnv5VU@kroah.com> <bO2GF-6sC-I4NbFif7JoGUpuRpAV-rHEMwtLsKfN9SCsA0lwB1NgEV4OC7Xd5fdoq3UPcZ6-uh2VDSe1Xtovy8ti3k5vmOsiMVTdfTgl0Yw=@protonmail.com> <YJD2uTdQonXymbn6@kroah.com> <npSsinT79DB6Ze8QTkmLcuOTyVwRcy2FbOf0tDjpEHbTxKdYmLar8Br66_ypLjzZ86sIJKnSbUHeehagPR6RqxsJsKdWW_vWnXOUEhMC14g=@protonmail.com> <YJFNyOGrF8RcTTlc@kroah.com> <g5YP678olZEf3yQNX2ptK3X6DceFoemqwzEgSJclx_dHFAJfbJBWznYtB74u5g69Onx_6QZkLF-K2muYLa3qsotkPpxbHYuz4Hrs94olZ7c=@protonmail.com> <YJFpxY6iFHMiPHFE@kroah.com>
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

On Tuesday, May 4, 2021 6:35 PM, Greg Kroah-Hartman <gregkh@linuxfoundation=
.org> wrote:
> Can you resend your backports here now, and properly let us know what
> kernel they belong into (again, the subject line is very confusing.)

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

