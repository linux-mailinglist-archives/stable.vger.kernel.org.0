Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0245D718
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 10:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbhKYJZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 04:25:40 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:57407 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349868AbhKYJXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 04:23:38 -0500
Received: (Authenticated sender: thomas.perrot@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 2C533240004;
        Thu, 25 Nov 2021 09:20:24 +0000 (UTC)
Message-ID: <ef1f38dced64c00f739f573c3b308445096cf660.camel@bootlin.com>
Subject: Re: [PATCH v4] bus: mhi: Fix race while handling SYS_ERR at power up
From:   Thomas Perrot <thomas.perrot@bootlin.com>
To:     Aleksander Morgado <aleksander@aleksander.es>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Date:   Thu, 25 Nov 2021 10:20:24 +0100
In-Reply-To: <CAAP7ucKnOEpt3_tj3+-A12+m2DPmfBO46wLs1F9gszQ95aUHdw@mail.gmail.com>
References: <20211124132221.44915-1-manivannan.sadhasivam@linaro.org>
         <CAAP7ucKnOEpt3_tj3+-A12+m2DPmfBO46wLs1F9gszQ95aUHdw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-7gADuLQMl3hEatd6WmKs"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-7gADuLQMl3hEatd6WmKs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Mani,

On Wed, 2021-11-24 at 16:17 +0100, Aleksander Morgado wrote:
> Hey Mani,
>=20
> On Wed, Nov 24, 2021 at 2:22 PM Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >=20
> > Some devices tend to trigger SYS_ERR interrupt while the host
> > handling
> > SYS_ERR state of the device during power up. This creates a race
> > condition and causes a failure in booting up the device.
> >=20
> > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > handling in mhi_async_power_up(). Once the host detects that the
> > device
> > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > process the reset request. During this time, the device triggers
> > SYS_ERR
> > interrupt to the host and host starts handling SYS_ERR execution.
> >=20
> > So by the time the device has completed reset, host starts SYS_ERR
> > handling. This causes the race condition and the modem fails to boot.
> >=20
> > Hence, register the IRQ handler only after handling the SYS_ERR check
> > to avoid getting spurious IRQs from the device.
> >=20
> > Cc: stable@vger.kernel.org
> > Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> > Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> > Signed-off-by: Manivannan Sadhasivam <
> > manivannan.sadhasivam@linaro.org>
> > ---
> >=20
> > Changes in v4:
> >=20
> > * Reverted the change that moved BHI_INTVEC as that was causing issue
> > as
> > =C2=A0 reported by Aleksander.
> >=20
> > Changes in v3:
> >=20
> > * Moved BHI_INTVEC setup after irq setup
> > * Used interval_us as the delay for the polling API
> >=20
> > Changes in v2:
> >=20
> > * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> >=20
>=20
> So far so good, works without issues in both reboots and cold boots.
> Thanks!
>=20

I also tested, I no longer observe reboot related issue on EM919x.
Thanks!

Best regards,
Thomas

> Posting here an example log for reference:
>=20
> root@OpenWrt:~# dmesg | grep mhi
> [=C2=A0=C2=A0=C2=A0 7.022756] mhi-pci-generic 0000:01:00.0: MHI PCI devic=
e found:
> sierra-em919x
> [=C2=A0=C2=A0=C2=A0 7.029931] mhi-pci-generic 0000:01:00.0: BAR 0: assign=
ed [mem
> 0x600000000-0x600000fff 64bit]
> [=C2=A0=C2=A0=C2=A0 7.038495] mhi-pci-generic 0000:01:00.0: enabling devi=
ce (0000 ->
> 0002)
> [=C2=A0=C2=A0=C2=A0 7.045311] mhi-pci-generic 0000:01:00.0: using shared =
MSI
> [=C2=A0=C2=A0=C2=A0 7.051420] mhi mhi0: Requested to power ON
> [=C2=A0=C2=A0=C2=A0 7.055637] mhi mhi0: Attempting power on with EE: PASS=
 THROUGH,
> state: SYS ERROR
> [=C2=A0=C2=A0=C2=A0 7.176024] mhi mhi0: Power on setup success
> [=C2=A0=C2=A0=C2=A0 7.176082] mhi mhi0: Handling state transition: PBL
> [=C2=A0=C2=A0=C2=A0 7.180322] mhi mhi0: local ee: INVALID_EE state: RESET=
 device ee:
> MISSION MODE state: READY
> [=C2=A0=C2=A0=C2=A0 7.193852] mhi mhi0: Device in READY State
> [=C2=A0=C2=A0=C2=A0 7.198043] mhi mhi0: Initializing MHI registers
> [=C2=A0=C2=A0=C2=A0 7.202712] mhi mhi0: Wait for device to enter SBL or M=
ission mode
> [=C2=A0=C2=A0 15.351002] mhi mhi0: local ee: MISSION MODE state: READY de=
vice
> ee: MISSION MODE state: READY
> [=C2=A0=C2=A0 15.509984] mhi mhi0: State change event to state: M0
> [=C2=A0=C2=A0 15.510001] mhi mhi0: local ee: MISSION MODE state: READY de=
vice
> ee: MISSION MODE state: M0
> [=C2=A0=C2=A0 15.523459] mhi mhi0: Received EE event: MISSION MODE
> [=C2=A0=C2=A0 15.523463] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 15.536629] mhi mhi0: Handling state transition: MISSION MOD=
E
> [=C2=A0=C2=A0 15.542393] mhi mhi0: Processing Mission Mode transition
> [=C2=A0=C2=A0 15.549246] mhi_net mhi0_IP_HW0: 100: Updating channel state=
 to:
> START
> [=C2=A0=C2=A0 15.647776] mhi_net mhi0_IP_HW0: 100: Channel state change t=
o START
> successful
> [=C2=A0=C2=A0 15.647795] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 15.663196] mhi_net mhi0_IP_HW0: 101: Updating channel state=
 to:
> START
> [=C2=A0=C2=A0 15.719309] mhi_net mhi0_IP_HW0: 101: Channel state change t=
o START
> successful
> [=C2=A0=C2=A0 15.719314] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 17.851014] mhi mhi0: Allowing M3 transition
> [=C2=A0=C2=A0 17.855347] mhi mhi0: Waiting for M3 completion
> [=C2=A0=C2=A0 17.987550] mhi mhi0: State change event to state: M3
> [=C2=A0=C2=A0 17.987568] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M3
> [=C2=A0=C2=A0 21.851920] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 21.876065] mhi mhi0: Entered with PM state: M3, MHI state: =
M3
> [=C2=A0=C2=A0 21.900513] mhi mhi0: State change event to state: M0
> [=C2=A0=C2=A0 21.900538] mhi mhi0: local ee: MISSION MODE state: M3 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 21.921710] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 21.921713] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 21.937308] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 21.946170] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 21.946172] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 21.981308] mhi_wwan_ctrl mhi0_DIAG: 4: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 21.990184] mhi_wwan_ctrl mhi0_DIAG: 4: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 21.990186] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.005697] mhi_wwan_ctrl mhi0_DIAG: 5: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 22.014547] mhi_wwan_ctrl mhi0_DIAG: 5: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 22.014549] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.043376] mhi_wwan_ctrl mhi0_DIAG: mhi_ul_xfer_cb: status:=
 0
> xfer_len: 5
> [=C2=A0=C2=A0 22.043380] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.050277] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.058371] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 0
> receive_len: 58
> [=C2=A0=C2=A0 22.073988] mhi_wwan_ctrl mhi0_DIAG: 5: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 22.082292] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.082294] mhi_wwan_ctrl mhi0_DIAG: 5: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 22.097778] mhi mhi0: Marking all events for chan: 5 as stal=
e
> [=C2=A0=C2=A0 22.103523] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 22.109271] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.116676] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.124076] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.131476] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.138874] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.146274] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.153672] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.161071] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.168470] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.175870] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.183268] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.190666] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.198065] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.205463] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.212862] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.220260] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.227660] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.235059] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.242457] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.249855] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.257253] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.264651] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.272049] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.279448] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.286846] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.294245] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.301643] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.309041] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.316440] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.323838] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.331237] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status:=
 -107
> receive_len: 0
> [=C2=A0=C2=A0 22.338666] mhi_wwan_ctrl mhi0_DIAG: 5: successfully reset
> [=C2=A0=C2=A0 22.344157] mhi_wwan_ctrl mhi0_DIAG: 4: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 22.352753] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.352758] mhi_wwan_ctrl mhi0_DIAG: 4: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 22.368356] mhi mhi0: Marking all events for chan: 4 as stal=
e
> [=C2=A0=C2=A0 22.374106] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 22.379910] mhi_wwan_ctrl mhi0_DIAG: 4: successfully reset
> [=C2=A0=C2=A0 22.388072] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 22.397188] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 22.397190] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 22.412690] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 22.424017] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 22.424021] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 25.917106] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 4
> [=C2=A0=C2=A0 25.917125] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 25.935842] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 4
> [=C2=A0=C2=A0 25.935852] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 25.942645] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 3
> [=C2=A0=C2=A0 25.950734] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 25.957768] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 6
> [=C2=A0=C2=A0 25.972897] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 3
> [=C2=A0=C2=A0 25.979950] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 6
> [=C2=A0=C2=A0 25.979953] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 25.995084] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 9
> [=C2=A0=C2=A0 25.995269] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 26.001872] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 8
> [=C2=A0=C2=A0 26.001879] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 39
> [=C2=A0=C2=A0 26.024415] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 26.024418] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 26.039893] mhi mhi0: Marking all events for chan: 33 as sta=
le
> [=C2=A0=C2=A0 26.045723] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 26.051468] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.058780] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.066092] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.073404] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.080715] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.088027] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.095337] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.102650] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.109965] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.117279] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.124589] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.131900] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.139211] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.146521] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.153831] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.161142] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.168452] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.175763] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.183073] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.190385] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.197695] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.205006] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.212315] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.219627] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.226937] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.234248] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.241558] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.248869] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 26.256206] mhi_wwan_ctrl mhi0_DUN: 33: successfully reset
> [=C2=A0=C2=A0 26.261695] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 26.270660] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 26.270669] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 26.286159] mhi mhi0: Marking all events for chan: 32 as sta=
le
> [=C2=A0=C2=A0 26.291992] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 26.297761] mhi_wwan_ctrl mhi0_DUN: 32: successfully reset
> [=C2=A0=C2=A0 30.355529] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.355543] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 30.362450] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.370546] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 30.377411] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 30.392643] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.399531] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.406757] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.413636] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.420863] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.427754] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.434992] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.441882] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.449115] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 30.456012] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.463268] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.470516] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 30.479754] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 30.489207] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 30.489210] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 30.504704] mhi mhi0: Marking all events for chan: 15 as sta=
le
> [=C2=A0=C2=A0 30.510536] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 30.516284] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.523598] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.530911] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.538224] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.545535] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.552847] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.560157] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.567468] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.574779] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.582091] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.589402] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.596713] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.604024] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.611335] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.618645] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.625957] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.633291] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.640618] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.647946] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.655297] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.662627] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.669949] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.677262] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.684572] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.691888] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.699199] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.706509] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.713820] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.721131] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.728441] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.735752] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
-107
> receive_len: 0
> [=C2=A0=C2=A0 30.743092] mhi_wwan_ctrl mhi0_QMI: 15: successfully reset
> [=C2=A0=C2=A0 30.748605] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel sta=
te to:
> RESET
> [=C2=A0=C2=A0 30.761269] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 30.769375] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change=
 to
> RESET successful
> [=C2=A0=C2=A0 30.776780] mhi mhi0: Marking all events for chan: 14 as sta=
le
> [=C2=A0=C2=A0 30.782613] mhi mhi0: Finished marking events as stale event=
s
> [=C2=A0=C2=A0 30.788371] mhi_wwan_ctrl mhi0_QMI: 14: successfully reset
> [=C2=A0=C2=A0 30.794771] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 30.803532] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 30.803535] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 30.819038] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 30.828331] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 30.828333] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 31.925717] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 12
> [=C2=A0=C2=A0 31.925723] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 31.932639] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 31.940747] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 31.955964] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 228
> [=C2=A0=C2=A0 31.978521] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 31.978523] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 31.985418] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 31.993503] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.012893] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.012897] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.019777] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 77
> [=C2=A0=C2=A0 32.027861] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.054892] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.054894] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.061787] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.069867] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 17
> [=C2=A0=C2=A0 32.084825] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.091966] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.123615] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.123618] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.130510] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.138594] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.168928] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.168935] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.183929] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.183937] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.203362] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.203363] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.210246] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.218328] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.236614] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.236616] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.243512] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.251618] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.269860] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.269862] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.276745] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.284834] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.304246] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.304247] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.311135] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.319241] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.339188] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 16
> [=C2=A0=C2=A0 32.339193] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.346078] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.354158] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.369801] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 32.379359] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 32.379361] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.394877] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel sta=
te to:
> START
> [=C2=A0=C2=A0 32.404051] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.404052] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change=
 to
> START successful
> [=C2=A0=C2=A0 32.423401] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 6
> [=C2=A0=C2=A0 32.423403] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.430201] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.438282] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.453242] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 294
> [=C2=A0=C2=A0 32.460474] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 5
> [=C2=A0=C2=A0 32.467535] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 6
> [=C2=A0=C2=A0 32.467538] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.482675] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.489557] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.489560] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 26
> [=C2=A0=C2=A0 32.489567] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 6
> [=C2=A0=C2=A0 32.504790] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.511569] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 6
> [=C2=A0=C2=A0 32.526694] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.533572] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 197
> [=C2=A0=C2=A0 32.533574] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.548873] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 11
> [=C2=A0=C2=A0 32.555749] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 6
> [=C2=A0=C2=A0 32.555752] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.562793] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.577748] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.577750] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 52
> [=C2=A0=C2=A0 32.577755] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 6
> [=C2=A0=C2=A0 32.592974] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.599753] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 9
> [=C2=A0=C2=A0 32.614877] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.621756] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.621758] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 29
> [=C2=A0=C2=A0 32.621765] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: =
0
> xfer_len: 7
> [=C2=A0=C2=A0 32.629862] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.636985] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: =
0
> receive_len: 9
> [=C2=A0=C2=A0 32.643764] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.651846] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.673835] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 77
> [=C2=A0=C2=A0 32.684996] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 27
> [=C2=A0=C2=A0 32.684998] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.691894] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.699994] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 20
> [=C2=A0=C2=A0 32.715206] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 29
> [=C2=A0=C2=A0 32.726784] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.726788] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.733667] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 26
> [=C2=A0=C2=A0 32.741756] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.759982] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.759985] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.766864] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 42
> [=C2=A0=C2=A0 32.774951] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.794333] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.794337] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.801215] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 145
> [=C2=A0=C2=A0 32.809294] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.828654] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.828657] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.835554] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.843638] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 24
> [=C2=A0=C2=A0 32.862183] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 20
> [=C2=A0=C2=A0 32.862186] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.869074] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.877162] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 27
> [=C2=A0=C2=A0 32.896556] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.896558] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.903446] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.911532] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 32.926749] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 116
> [=C2=A0=C2=A0 32.938214] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.938223] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.945134] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 116
> [=C2=A0=C2=A0 32.953218] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.972615] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 32.972619] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 32.979497] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 20
> [=C2=A0=C2=A0 32.987579] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 33.005791] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 33.005793] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 33.012673] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 33.020759] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 35.011999] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 35.012012] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 35.018924] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 35.027016] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 35.034131] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 37.011548] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 37.011554] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 37.018476] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 37.026567] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 39.012483] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 39.012497] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 39.019413] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 39.027510] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 39.034617] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 41.010833] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 41.010839] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 41.017760] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 41.025856] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 43.010424] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 43.010431] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 43.017356] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 43.025455] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 45.009911] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: =
0
> xfer_len: 13
> [=C2=A0=C2=A0 45.009918] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 45.016839] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 45.024933] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 90
> [=C2=A0=C2=A0 47.523933] mhi mhi0: Allowing M3 transition
> [=C2=A0=C2=A0 47.528247] mhi mhi0: Waiting for M3 completion
> [=C2=A0=C2=A0 47.569544] mhi mhi0: State change event to state: M3
> [=C2=A0=C2=A0 47.569567] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M3
> [=C2=A0=C2=A0 48.632075] mhi mhi0: Entered with PM state: M3, MHI state: =
M3
> [=C2=A0=C2=A0 48.650239] mhi mhi0: State change event to state: M0
> [=C2=A0=C2=A0 48.650247] mhi mhi0: local ee: MISSION MODE state: M3 devic=
e ee:
> MISSION MODE state: M0
> [=C2=A0=C2=A0 48.667040] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: =
0
> receive_len: 12
> [=C2=A0=C2=A0 48.667043] mhi mhi0: local ee: MISSION MODE state: M0 devic=
e ee:
> MISSION MODE state: M0
>=20
>=20
>=20
>=20

--=20
Thomas Perrot, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com


--=-7gADuLQMl3hEatd6WmKs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQGzBAABCAAdFiEEh0B3xqajCiMDqBIhn8ALBXH+Cu0FAmGfVVgACgkQn8ALBXH+
Cu0AKgv/RTWXtUHqC0J/Ld0ES78Bvr98plQvbOen47G7P+TpdtgAj8rLtuK88kKz
hDbWUa7ys+ELKIRuZtuCVrfyLdvRkk+mCFA3HQwdza7V8HQ9yO3xERluD5AjTA8Q
6GkzFeIWQNgqqGqSLg+lyUZ1LZSgSvpTddjXu3rFNK02sh4hk+cLMI8NW0/pqZTX
cf0dF49SK08+avtz98fSCJbHxQ5euXFrmlZL4FEI2V8EBPY1YyobG3xQJT5dviAS
52WoxrsKiI/29n+NOd6rKv7XnvMs25qTcmUKMJ62IeQEMJ1HRih4tgSUXh+PRtDu
B3boGYotvbUkMEkfiGRhMI1fvHg1YdJ2WO3h70Jpa6ttJaaC2Y6475ZHCkCreGGq
6IXVawiSPPQ79Ybsk6SSEMKZfQBxDmV3NsxV1YwtqfR3/eoXUb381hERcMhn4gwe
5/llRo9VwfSn+OBE9+ii+2KRbbJfPTDHQnZtlm/Sw1DrDnvgdGbTrVTO3sGWRqFT
OxTF6gJm
=OdW6
-----END PGP SIGNATURE-----

--=-7gADuLQMl3hEatd6WmKs--

