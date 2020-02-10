Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5208C157EE0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 16:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBJPfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 10:35:31 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43246 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJPfb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 10:35:31 -0500
Received: by mail-pf1-f193.google.com with SMTP id s1so3864290pfh.10
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 07:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vHTzd+CnWobBfS0/01KE8KFjhCDe3Pck0cjBoLW1qhY=;
        b=E29EjGZpUENTXavjaMIihRKEftiugdCjWLo0HHr+/ojqMM5UUwTG8pQ9/W9SEsG5q+
         /Wiw3rXrUeZP14z2rHHk9msxCEjcUCE15uDPRrNI03B5LsojEZ8oRwbk0Vvgk7a9ujOT
         TlMRTwlnrmkgI5/52hMqXkPO0TmTUMu2aA5RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vHTzd+CnWobBfS0/01KE8KFjhCDe3Pck0cjBoLW1qhY=;
        b=DP6m8qPlEwMYs4nh3j2RJkQCO2VQfcmJHZw2InAm4aCDh7xSC0I7NTtbnCXiNQL+um
         73nylnccV6P3+Ksphv74RWISGwhVpmxT6yJ75eFSy9Vpxllk5CJfYEhkXZnOQkYaHj8C
         O9S3nJvgqAZe+WeiFhGJAjL5M9ph16PaOw5LIMUEkjX84HAsB9x9Q91ipK2ZXJwrPJ7J
         Kb7CYClOR0uM3uiKMqppcv8KAVl4d7Kf5ryDosb5WPxWp8VudWUBKcvj8olNHa8pxzSM
         Y0R37QDByRTruRUxjMccNmvWrzinKVDlhCeSi6cXYddQLy0kZjs1UbwDQgReMd/8m8gT
         eKtw==
X-Gm-Message-State: APjAAAWM+8URs3s1d/eSQVwF731T5nmhGZOS7a6pubiRm2+AF0mopHEn
        PPE7gd7Sw1Ecb/r5yCNnXGNi0g==
X-Google-Smtp-Source: APXvYqywLp19FJB2XM7IqSfy0acjCo8F5N9OUp/Js6Vq5wUp1AlCSyip1vfBl9xWv/eJT1yGMcUURQ==
X-Received: by 2002:a63:e011:: with SMTP id e17mr2307573pgh.49.1581348930146;
        Mon, 10 Feb 2020 07:35:30 -0800 (PST)
Received: from [192.168.0.103] (modemcable127.167-81-70.mc.videotron.ca. [70.81.167.127])
        by smtp.gmail.com with ESMTPSA id d24sm804742pfq.75.2020.02.10.07.35.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2020 07:35:29 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] Revert "target/core: Inline transport_lun_remove_cmd()"
From:   Pavel Zakharov <pavel.zakharov@delphix.com>
In-Reply-To: <20200210051202.12934-1-bvanassche@acm.org>
Date:   Mon, 10 Feb 2020 10:35:27 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C9DC161-FB80-4675-BDF4-3795F96B92EB@delphix.com>
References: <20200210051202.12934-1-bvanassche@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you Bart for such a fast response!

This LGTM.

Pavel

> On Feb 10, 2020, at 12:12 AM, Bart Van Assche <bvanassche@acm.org> =
wrote:
>=20
> Commit 83f85b8ec305 postponed the =
percpu_ref_put(&se_cmd->se_lun->lun_ref)
> call from command completion to the time when the final command =
reference
> is dropped. That approach is not compatible with the iSCSI target =
driver
> because the iSCSI target driver keeps the command with the highest =
stat_sn
> after it has completed until the next command is received (see also
> iscsit_ack_from_expstatsn()). Fix this regression by reverting commit
> 83f85b8ec305.
>=20
> Reported-by: Pavel Zakharov <pavel.zakharov@delphix.com>
> Cc: Pavel Zakharov <pavel.zakharov@delphix.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 83f85b8ec305 ("scsi: target/core: Inline =
transport_lun_remove_cmd()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/target/target_core_transport.c | 31 +++++++++++++++++++++++---
> 1 file changed, 28 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/target/target_core_transport.c =
b/drivers/target/target_core_transport.c
> index ea482d4b1f00..0ae9e60fc4d5 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -666,6 +666,11 @@ static int =
transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
>=20
> 	target_remove_from_state_list(cmd);
>=20
> +	/*
> +	 * Clear struct se_cmd->se_lun before the handoff to FE.
> +	 */
> +	cmd->se_lun =3D NULL;
> +
> 	spin_lock_irqsave(&cmd->t_state_lock, flags);
> 	/*
> 	 * Determine if frontend context caller is requesting the =
stopping of
> @@ -693,6 +698,17 @@ static int =
transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
> 	return cmd->se_tfo->check_stop_free(cmd);
> }
>=20
> +static void transport_lun_remove_cmd(struct se_cmd *cmd)
> +{
> +	struct se_lun *lun =3D cmd->se_lun;
> +
> +	if (!lun)
> +		return;
> +
> +	if (cmpxchg(&cmd->lun_ref_active, true, false))
> +		percpu_ref_put(&lun->lun_ref);
> +}
> +
> static void target_complete_failure_work(struct work_struct *work)
> {
> 	struct se_cmd *cmd =3D container_of(work, struct se_cmd, work);
> @@ -783,6 +799,8 @@ static void target_handle_abort(struct se_cmd =
*cmd)
>=20
> 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) =3D=3D 0);
>=20
> +	transport_lun_remove_cmd(cmd);
> +
> 	transport_cmd_check_stop_to_fabric(cmd);
> }
>=20
> @@ -1708,6 +1726,7 @@ static void target_complete_tmr_failure(struct =
work_struct *work)
> 	se_cmd->se_tmr_req->response =3D TMR_LUN_DOES_NOT_EXIST;
> 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);
>=20
> +	transport_lun_remove_cmd(se_cmd);
> 	transport_cmd_check_stop_to_fabric(se_cmd);
> }
>=20
> @@ -1898,6 +1917,7 @@ void transport_generic_request_failure(struct =
se_cmd *cmd,
> 		goto queue_full;
>=20
> check_stop:
> +	transport_lun_remove_cmd(cmd);
> 	transport_cmd_check_stop_to_fabric(cmd);
> 	return;
>=20
> @@ -2195,6 +2215,7 @@ static void transport_complete_qf(struct se_cmd =
*cmd)
> 		transport_handle_queue_full(cmd, cmd->se_dev, ret, =
false);
> 		return;
> 	}
> +	transport_lun_remove_cmd(cmd);
> 	transport_cmd_check_stop_to_fabric(cmd);
> }
>=20
> @@ -2289,6 +2310,7 @@ static void target_complete_ok_work(struct =
work_struct *work)
> 		if (ret)
> 			goto queue_full;
>=20
> +		transport_lun_remove_cmd(cmd);
> 		transport_cmd_check_stop_to_fabric(cmd);
> 		return;
> 	}
> @@ -2314,6 +2336,7 @@ static void target_complete_ok_work(struct =
work_struct *work)
> 			if (ret)
> 				goto queue_full;
>=20
> +			transport_lun_remove_cmd(cmd);
> 			transport_cmd_check_stop_to_fabric(cmd);
> 			return;
> 		}
> @@ -2349,6 +2372,7 @@ static void target_complete_ok_work(struct =
work_struct *work)
> 			if (ret)
> 				goto queue_full;
>=20
> +			transport_lun_remove_cmd(cmd);
> 			transport_cmd_check_stop_to_fabric(cmd);
> 			return;
> 		}
> @@ -2384,6 +2408,7 @@ static void target_complete_ok_work(struct =
work_struct *work)
> 		break;
> 	}
>=20
> +	transport_lun_remove_cmd(cmd);
> 	transport_cmd_check_stop_to_fabric(cmd);
> 	return;
>=20
> @@ -2710,6 +2735,9 @@ int transport_generic_free_cmd(struct se_cmd =
*cmd, int wait_for_tasks)
> 		 */
> 		if (cmd->state_active)
> 			target_remove_from_state_list(cmd);
> +
> +		if (cmd->se_lun)
> +			transport_lun_remove_cmd(cmd);
> 	}
> 	if (aborted)
> 		cmd->free_compl =3D &compl;
> @@ -2781,9 +2809,6 @@ static void target_release_cmd_kref(struct kref =
*kref)
> 	struct completion *abrt_compl =3D se_cmd->abrt_compl;
> 	unsigned long flags;
>=20
> -	if (se_cmd->lun_ref_active)
> -		percpu_ref_put(&se_cmd->se_lun->lun_ref);
> -
> 	if (se_sess) {
> 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
> 		list_del_init(&se_cmd->se_cmd_list);

