Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7313711D1
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 09:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhECHER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 03:04:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:58578 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhECHEQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 03:04:16 -0400
IronPort-SDR: XDOQ18ICv6CFLJwzuv6W71BXb4D6PNm8JlIJzbGsTGfZmOcCMHNBivxCFShFcVMVYHCQbs0D3n
 EQbwBzwvpaxg==
X-IronPort-AV: E=McAfee;i="6200,9189,9972"; a="195623104"
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="195623104"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2021 00:03:24 -0700
IronPort-SDR: 8oUrSgV9yXCo5Cm43B7qOj8sJVx+aSfGmPPcGnjngUowaibMAHeNx+3rfGhN+1u8N39eOMJivi
 5pI8WiUeO9zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,268,1613462400"; 
   d="scan'208";a="530264371"
Received: from kuha.fi.intel.com ([10.237.72.162])
  by fmsmga001.fm.intel.com with SMTP; 03 May 2021 00:03:21 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 03 May 2021 10:03:20 +0300
Date:   Mon, 3 May 2021 10:03:20 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Jack Pham <jackp@codeaurora.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Abhilash K V <abhilash.k.v@intel.com>
Subject: Re: [PATCH] usb: typec: ucsi: Retrieve all the PDOs instead of just
 the first 4
Message-ID: <YI+gOBPTZF+Rafv7@kuha.fi.intel.com>
References: <20210426191825.30721-1-jackp@codeaurora.org>
 <20210426192605.GB20698@jackp-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426192605.GB20698@jackp-linux.qualcomm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Apr 26, 2021 at 12:26:05PM -0700, Jack Pham wrote:
> Forgot to Cc: Abhilash who introduced the PDO code
> 
> On Mon, Apr 26, 2021 at 12:18:25PM -0700, Jack Pham wrote:
> > commit 4dbc6a4ef06d ("usb: typec: ucsi: save power data objects
> > in PD mode") introduced retrieval of the PDOs when connected to a
> > PD-capable source. But only the first 4 PDOs are received since
> > that is the maximum number that can be fetched at a time given the
> > MESSAGE_IN length limitation (16 bytes). However, as per the PD spec
> > a connected source may advertise up to a maximum of 7 PDOs.
> > 
> > If such a source is connected it's possible the UCSI FW could have
> > negotiated a power contract with one of the PDOs at index greater
> > than 4, and would be reflected in the request data object's (RDO)
> > object position field. This would result in an out-of-bounds access
> > when the rdo_index() is used to index into the src_pdos array in
> > ucsi_psy_get_voltage_now().
> > 
> > We can resolve this by instead retrieving and storing up to the
> > maximum of 7 PDOs in the con->src_pdos array. This would involve
> > two calls to the GET_PDOS command.

This makes sense to me. A few nitpicks below. Besides those:

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> > Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
> > Fixes: 4dbc6a4ef06d ("usb: typec: ucsi: save power data objects in PD mode")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jack Pham <jackp@codeaurora.org>
> > ---
> >  drivers/usb/typec/ucsi/ucsi.c | 41 +++++++++++++++++++++++++++--------
> >  drivers/usb/typec/ucsi/ucsi.h |  6 +++--
> >  2 files changed, 36 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
> > index 244270755ae6..ac214b855986 100644
> > --- a/drivers/usb/typec/ucsi/ucsi.c
> > +++ b/drivers/usb/typec/ucsi/ucsi.c
> > @@ -495,7 +495,8 @@ static void ucsi_unregister_altmodes(struct ucsi_connector *con, u8 recipient)
> >  	}
> >  }
> >  
> > -static void ucsi_get_pdos(struct ucsi_connector *con, int is_partner)
> > +static int ucsi_get_pdos(struct ucsi_connector *con, int is_partner,
> > +		u32 *pdos, int offset, int num_pdos)

That should be aligned properly.

> >  {
> >  	struct ucsi *ucsi = con->ucsi;
> >  	u64 command;
> > @@ -503,17 +504,39 @@ static void ucsi_get_pdos(struct ucsi_connector *con, int is_partner)
> >  
> >  	command = UCSI_COMMAND(UCSI_GET_PDOS) | UCSI_CONNECTOR_NUMBER(con->num);
> >  	command |= UCSI_GET_PDOS_PARTNER_PDO(is_partner);
> > -	command |= UCSI_GET_PDOS_NUM_PDOS(UCSI_MAX_PDOS - 1);
> > +	command |= UCSI_GET_PDOS_PDO_OFFSET(offset);
> > +	command |= UCSI_GET_PDOS_NUM_PDOS(num_pdos - 1);
> >  	command |= UCSI_GET_PDOS_SRC_PDOS;
> > -	ret = ucsi_send_command(ucsi, command, con->src_pdos,
> > -			       sizeof(con->src_pdos));
> > -	if (ret < 0) {
> > +	ret = ucsi_send_command(ucsi, command, pdos + offset,
> > +			num_pdos * sizeof(u32));

That too. I think if you run scripts/checkpatch.pl it will complain
about those.

> > +	if (ret < 0)
> >  		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
> > +	if (ret == 0 && offset == 0)
> > +		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
> > +
> > +	return ret;
> > +}
> > +
> > +static void ucsi_get_src_pdos(struct ucsi_connector *con, int is_partner)
> > +{
> > +	int ret;
> > +
> > +	/* UCSI max payload means only getting at most 4 PDOs at a time */
> > +	ret = ucsi_get_pdos(con, 1, con->src_pdos, 0, UCSI_MAX_PDOS);
> > +	if (ret < 0)
> >  		return;
> > -	}
> > +
> >  	con->num_pdos = ret / sizeof(u32); /* number of bytes to 32-bit PDOs */
> > -	if (ret == 0)
> > -		dev_warn(ucsi->dev, "UCSI_GET_PDOS returned 0 bytes\n");
> > +	if (con->num_pdos < UCSI_MAX_PDOS)
> > +		return;
> > +
> > +	/* get the remaining PDOs, if any */
> > +	ret = ucsi_get_pdos(con, 1, con->src_pdos, UCSI_MAX_PDOS,
> > +			PDO_MAX_OBJECTS - UCSI_MAX_PDOS);
> > +	if (ret < 0)
> > +		return;
> > +
> > +	con->num_pdos += ret / sizeof(u32);
> >  }
> >  
> >  static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
> > @@ -522,7 +545,7 @@ static void ucsi_pwr_opmode_change(struct ucsi_connector *con)
> >  	case UCSI_CONSTAT_PWR_OPMODE_PD:
> >  		con->rdo = con->status.request_data_obj;
> >  		typec_set_pwr_opmode(con->port, TYPEC_PWR_MODE_PD);
> > -		ucsi_get_pdos(con, 1);
> > +		ucsi_get_src_pdos(con, 1);
> >  		break;
> >  	case UCSI_CONSTAT_PWR_OPMODE_TYPEC1_5:
> >  		con->rdo = 0;
> > diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
> > index 3920e20a9e9e..cee666790907 100644
> > --- a/drivers/usb/typec/ucsi/ucsi.h
> > +++ b/drivers/usb/typec/ucsi/ucsi.h
> > @@ -8,6 +8,7 @@
> >  #include <linux/power_supply.h>
> >  #include <linux/types.h>
> >  #include <linux/usb/typec.h>
> > +#include <linux/usb/pd.h>
> >  #include <linux/usb/role.h>
> >  
> >  /* -------------------------------------------------------------------------- */
> > @@ -134,7 +135,9 @@ void ucsi_connector_change(struct ucsi *ucsi, u8 num);
> >  
> >  /* GET_PDOS command bits */
> >  #define UCSI_GET_PDOS_PARTNER_PDO(_r_)		((u64)(_r_) << 23)
> > +#define UCSI_GET_PDOS_PDO_OFFSET(_r_)		((u64)(_r_) << 24)
> >  #define UCSI_GET_PDOS_NUM_PDOS(_r_)		((u64)(_r_) << 32)
> > +#define UCSI_MAX_PDOS				(4)
> >  #define UCSI_GET_PDOS_SRC_PDOS			((u64)1 << 34)
> >  
> >  /* -------------------------------------------------------------------------- */
> > @@ -302,7 +305,6 @@ struct ucsi {
> >  
> >  #define UCSI_MAX_SVID		5
> >  #define UCSI_MAX_ALTMODES	(UCSI_MAX_SVID * 6)
> > -#define UCSI_MAX_PDOS		(4)
> >  
> >  #define UCSI_TYPEC_VSAFE5V	5000
> >  #define UCSI_TYPEC_1_5_CURRENT	1500
> > @@ -330,7 +332,7 @@ struct ucsi_connector {
> >  	struct power_supply *psy;
> >  	struct power_supply_desc psy_desc;
> >  	u32 rdo;
> > -	u32 src_pdos[UCSI_MAX_PDOS];
> > +	u32 src_pdos[PDO_MAX_OBJECTS];
> >  	int num_pdos;
> >  
> >  	struct usb_role_switch *usb_role_sw;

thanks,

-- 
heikki
